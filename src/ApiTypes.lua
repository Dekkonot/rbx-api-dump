--!strict

type Array<T> = { [number]: T }

type ValueType = {
	Category: string,
	Name: string,
}

export type Property = {
	Category: string,
	MemberType: string,
	Name: string,
	Security: { Read: string, Write: string },
	Serialization: {
		CanLoad: boolean,
		CanSave: boolean,
	},
	ValueType: ValueType,

	Tags: Array<string>?,
}

export type Function = {
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

export type Event = {
	MemberType: string,
	Name: string,
	Parameters: Array<{
		Name: string,
		Type: ValueType,
	}>,
	Security: string,

	Tags: Array<string>?,
}

export type Callback = {
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

export type Member = {
	MemberType: string,
	Name: string,
	Security: { Read: string, Write: string } | string,

	Category: string?,
	Serialization: {
		CanLoad: boolean,
		CanSave: boolean,
	}?,
	ValueType: ValueType?,

	Parameters: Array<{
		Name: string,
		Type: ValueType,
	}>?,
	ReturnType: ValueType?,

	Tags: Array<string>?,
}

export type Class = {
	Members: Array<Member>,
	MemoryCategory: string,
	Name: string,
	Superclass: string,
	Tags: Array<string>?,
}

export type Enum = {
	Items: Array<{ Name: string, Value: string }>,
	Name: string,
	Tags: Array<string>?,
}

export type API = {
	Classes: Array<Class>,
	Enums: Array<Enum>,
	Version: number,
}

return true
