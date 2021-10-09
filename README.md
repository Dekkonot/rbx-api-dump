# rbx-api-dump

A simple and reasonable module for processing the Roblox API dump from inside Roblox. In addition to fulfilling a use case, this module also acted as an experimental use of Roblox's typed Luau. As a result, this module can be considered to be fully typesafe.

This module pulls directly from Roblox's CDN, so it requires two HTTP requests to be sent when it's first required. Both of these requests are simple GET requests.

To get the project you can:
 - Build it using [Rojo](https://github.com/Roblox/rojo) 6+ by running `rojo build -o api-dump.rbxmx`
 - Grab the latest version from [Releases](https://github.com/dekkonot/rbx-api-dump/releases)
 - Install it using [Wally](https://github.com/UpliftGames/wally) by referencing `dekkonot/api-dump`

## API

As with every module, there's a set list of API. Luckily, the API for this module is rather simple.

When you require the module, it will immediately try to send two HTTP requests to get the API dump from Roblox. If it doesn't succeed, it retries after 1 second, then after 2 seconds, then 4, and so on.

To check if the API has returned successfully, this module provides two things: a function that returns if it's ready, and a signal that fires when it's ready.

### isReady

```plaintext
API.isReady(): boolean
```

Returns whether or not the module is ready to use.

### readyEvent

```plaintext
API.readyEvent: RBXScriptSignal
```

A signal that fires when the module is ready to use. Because it's a signal, you can also wait for it to be ready with `:Wait()`.

A good pattern to use might be:

```lua
if not API.isReady() then
    API.readyEvent:Wait()
end
```

After the module is ready, all of the other functions can be used:

### getClasses

```plaintext
API.getClasses(filter: Array<string>?): Array<string>
```

Returns a list of ClassNames. If `filter` is provided, any classes that have tags inside `filter` will be excluded from the returned list.

Thus, something like this:

```lua
API.getClasses({"Deprecated"})
```

Would return a list of classes that weren't deprecated.

### getEnums

```plaintext
API.getEnums(filter: Array<string>?): Array<string>
```

Returns a list of Enum names. If `filter` is provided, it functions identically to the `filter` in [`getClasses`](#getclasses).

### getSuperclasses

```plaintext
API.getSuperclasses(class: string): Array<string>
```

Returns a list of superclassses for the given ClassName. The array is guaranteed to be in order of inheritance. This means that iterating through the array will list the ClassNames with `Instance` in the first position and so on, with the final Classname (`class`) in the final position.

### getTags

```plaintext
API.getTags(class: string, member: string?): Array<string>
```

Returns a list of tags on a particular class or member. If `member` is provide, it will return the tags on `class.member`, otherwise it will return the tags on `class`. The tags on a class is subject to change from version to version, and the order of the returned list is not guaranteed.

### isDeprecated

```plaintext
API.isDeprecated(class: strimg, member: string?): boolean
```

Returns whether a given class or member is deprecated or not. If `member` is provided, it will return whether `class.member` is deprecated, otherwise it will whether `class` is or not.

### isService

```plaintext
API.isService(class: string): boolean
```

Returns whether the given class is a Service or not. Essentially equivalent to `not not table.find(API.getTags(class), "Service"))`.

### getMembers

```plaintext
API.getMembers(class: string, tagFilter: Array<string>?, securityFilter: Array<string>?): Dictionary<Member>
```

Returns a dictionary representing all of a given class's [members](#member).

If `tagFilter` is provided, it acts an exclusion filter for the tags on members. Thus, something like `API.getMembers("Instance", {"Deprecated"})` would return all members of Instance that weren't tagged with `Deprecated`.

If `securityFilter` is provided, it acts identically, except that instead of filtering tags it filters the security of members. For ease of use, some common filters are provided in [filters](#filters)

### getProperties

```plaintext
API.getProperties(class: string, tagFilter: Array<string>?, securityFilter: Array<string>?): Dictionary<Property>
```

Functions identically to [getMembers](#getmembers) but only returns [properties](#properties).

### getFunctions

```plaintext
API.getFunctions(class: string, tagFilter: Array<string>?, securityFilter: Array<string>?): Dictionary<Function>
```

Functions identically to [getMembers](#getmembers) but only returns [functions](#function) (methods).

### getEvents

```plaintext
API.getEvents(class: string, tagFilter: Array<string>?, securityFilter: Array<string>?): Dictionary<Event>
```

Functions identically to [getMembers](#getmembers) but only returns [events](#event).

### getCallbacks

```plaintext
API.getCallbacks(class: string, tagFilter: Array<string>?, securityFilter: Array<string>?): Dictionary<Callback>
```

Functions identically to [getMembers](#getmembers) but only returns [callbacks](#callback).

## Types

For the sake of convenience, several types are defined by the module. They can be referenced by indexing the variable that stores that module (e.g. if the module was stored in `API` you would access `Member` with `API.Member`).

Each type definition is provided below, along with what they represent.

### Member

```lua
type Member = {
    MemberType: string,
    Name: string,
    Security: { Read: string, Write: string, } | string,

    Category: string?,
    Serialization: { CanLoad: boolean, CanSave: boolean, }?,
    ValueType: { Category: string, Name: string, }?,

    Parameters: Array<{
        Name: string,
        Type: {
            Category: string,
            Name: string,
        },
    }>?,
    ReturnType: { Category: string, Name: string, }?,

    Tags: Array<string>?,
}
```

The `Member` type is used to represent any member of a class, so as a result is incredibly non-specific. The `MemberType` entry of the type will let you clarify what type a member is -- it will always be one of the following: `"Property"`, `"Function"`, `"Event"`, or `"Callback"`.

Certain fields are present on all Members, regardless of their MemberType. To avoid repetition, they are described here:

- `MemberType` - What type of member something is -- it will always be one of: `"Property"`, `"Function"`, `"Event"`, or `"Callback"`.
- `Name` - What the name of a member is.
- `Security` - A table containing details on what can access a property. In the case of Properties, this field is a table that indicates what can read and write it. Otherwise, it's a string.
- `Tags` - A list of tags that appear on a particular member. These tags are subject to change and this field may or not be present on any given member.

### Property

```lua
type Property = {
    Category: string,
    MemberType: "Property",
    Name: string,
    Security: { Read: string, Write: string, },
    Serialization: { CanLoad: boolean, CanSave: boolean, },
    ValueType: ValueType,

    Tags: Array<string>?,
}
```

The `Property` type is used to represent Properties of a class. A quick description of each of the fields is below:

- `Category` - An arbitrary category decided on by Roblox that describes what a property does.
- `Serialization` - A table containing details on whether a property serializes when its Instance is saved to or loaded from a model or place.
- `ValueType` - A table containing details on what data type a property is. See [ValueType](#valuetype) for more details.

### Function

```lua
type Function = {
    MemberType: string,
    Name: string,
    Parameters: Array<{
        Name: string,
        Type: ValueType,
    }>,
    ReturnType: ValueType,
    Security: string,

    Tags: Array<string>?,
}
```

The `Function` type is used to represent Methods of a class. The term Method is not used to maintain parity with the API dump. A quick description of each of the fields is below:

- `Parameters` - An array containing tables that contain the name of a particular argument and its value. For information on the value, see [ValueType](#valuetype).
- `ReturnType` - The return type of a Function. See [ValueType](#valuetype).

### Event

```lua
type Event = {
    MemberType: string,
    Name: string,
    Parameters: Array<{ Name: string, Type: ValueType, }>,
    Security: string,

    Tags: Array<string>?,
}
```

The `Event` type is used to represent Events of a class. A quick description of each of the fields is below:

- `Parameters` - An array containing tables that contain the name of a particular argument and its value. For more information on the value, see [ValueType](#valuetype).

### Callback

```lua
type Callback = {
    MemberType: string,
    Name: string,
    Parameters: Array<{ Name: string, Type: ValueType, }>,
    ReturnType: ValueType,
    Security: string,

    Tags: Array<string>?,
}
```

The `Callback` type is used to represent Callbacks of a class. A quick description of each of the fields is below:

- `Parameters` - An array containing tables that contain the name of a particular argument and its value. For information on the value, see [ValueType](#valuetype).
- `ReturnType` - The expected return type of a Callback. See [ValueType](#valuetype).

### ValueType

```lua
type ValueType = {
    Category: string,
    Name: string,
}
```

The `ValueType` type is used to represent a type of value. Because the pattern comes up so often, it is given its own type.

If `Category` is `Enum`, then `ValueType.Name` is the type of Enum it is. Otherwise, `ValueType.Name` indicates the actual type of a value something is. Note that this won't necessarily correspond to the type as it appears in Roblox.

## Filters

For the sake of convenience, multiple filters are provided under `API.filters`. They're seperated into 3 categories, each with their own respective fields. A filter can be accessed with `API.filters.`**`Category`**.**`Filter`**, where `Category` and `Filter` are filled in from below:

### Security

This category contains filters that can be used for the `securityFilter` argument of various functions. They are:

- `None` - Nothing is filtered.
- `CoreScript` - Everything that is inaccessible to CoreScripts is filtered.
- `Plugin` - Everything that is inaccessible to Plugins is filtered.
- `Normal` - Everything that is inaccessible to normal scripts is filtered.

### Members

This category contains filters that for class members that can be used as the `tagFilter` argument of various functions. They are:

- `None` - Nothing is filtered.
- `Writable` - Filters readonly and nonscriptable properties.
- `Sync` - Filters things that yield or can yield.
- `NotDeprecated` - Filters deprecated members.
- `Normal` - Combines `Writable` and `NotDeprecated`. This is generally the 'normal' when wanting to know what members a class has, so for convenience it is provided.

### Class

This category contains filters for classes that can be used as the `filter` argument of [`getClasses`](#getclasses). They are:

- `None` - Nothing is filtered.
- `NonService` - Services are filtered.
- `NotDeprecated` - Deprecated classes are filtered.
- `NotSettings` - Settings classes are deprecated.
