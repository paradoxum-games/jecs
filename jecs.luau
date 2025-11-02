--!optimize 2
--!native
-- Removed strict to prioritize runtime functionality for snapshot/restore integration
--!nonstrict
--draft 4

type i53 = number
type i24 = number

type Ty = { i53 }
type ArchetypeId = number

type Column = { any }
type Map<K, V> = { [K]: V }

-- Revert to numeric entity/component identity for internal system consistency.
type Entity = i53
type Id = i53
type Pair<P, O> = i53
type ecs_id_t = i53

export type Archetype = {
	id: number,
	types: Ty,
	type: string,
	entities: { Entity },
	columns: { Column },
	columns_map: { [Id]: Column },
}

export type QueryInner = {
	compatible_archetypes: { Archetype },
	ids: { Id },
	filter_with: { Id },
	filter_without: { Id }?,
	next: () -> (Entity, ...any),
	world: World,
}

export type Item<T...> = (self: Query<T...>) -> (Entity, T...)
export type Iter<T...> = (query: Query<T...>) -> () -> (Entity, T...)

export type Query<T...> = typeof(setmetatable(
	{} :: {
		iter: Iter<T...>,
		with: (Query<T...>, ...Id) -> Query<T...>,
		without: (Query<T...>, ...Id) -> Query<T...>,
		archetypes: (self: Query<T...>) -> { Archetype },
		cached: (self: Query<T...>) -> Query<T...>,
		ids: { Id },
		filter_with: { Id }?,
		filter_without: { Id }?,
	},
	{} :: { __iter: Iter<T...> }
))

export type Observer = {
	callback: (archetype: Archetype) -> (),
	query: QueryInner,
}

type query = {
	compatible_archetypes: { archetype },
	ids: { i53 },
	filter_with: { i53 },
	filter_without: { i53 },
	next: () -> (i53, ...any),
	world: world,
}

export type observer = {
	callback: (archetype: archetype) -> (),
	query: query,
}

type archetype = {
	id: number,
	types: { i53 },
	type: string,
	entities: { i53 },
	columns: { Column },
	columns_map: { [i53]: Column },
}

type componentrecord = {
	component: i53,
	records: { [number]: number },
	counts: { [i53]: number },
	flags: number,
	size: number,

	on_add: ((entity: i53, id: i53, value: any, oldarchetype: archetype) -> ())?,
	on_change: ((entity: i53, id: i53, value: any, oldarchetype: archetype) -> ())?,
	on_remove: ((entity: i53, id: i53) -> ())?,

	wildcard_pairs: { [number]: componentrecord },
}
type record = {
	archetype: archetype,
	row: number,
	dense: i24,
}
type entityindex = {
	dense_array: Map<number, i53>,
	sparse_array: Map<i24, record>,
	alive_count: number,
	max_id: number,
	range_begin: number?,
	range_end: number?,
}
type world = {
	archetype_edges: Map<i53, Map<i53, archetype>>,
	archetype_index: { [string]: archetype },
	archetypes: { [i53]: archetype },
	component_index: Map<i53, componentrecord>,
	entity_index: entityindex,
	ROOT_ARCHETYPE: archetype,

	max_component_id: number,
	max_archetype_id: number,

	observable: Map<i53, Map<i53, { Observer }>>,

	range: (self: world, range_begin: number, range_end: number?) -> (),
	entity: (self: world, id: i53?) -> i53,
	component: (self: world) -> i53,
	target: (self: world, id: i53, relation: i53, index: number?) -> i53?,
	delete: (self: world, id: i53) -> (),
	add: (self: world, id: i53, component: i53) -> (),
	set: (self: world, id: i53, component: i53, data: any) -> (),
	cleanup: (self: world) -> (),
	clear: (self: world, entity: i53) -> (),
	remove: (self: world, id: i53, component: i53) -> (),
	get: (world, ...i53) -> (),
	has: (world, ...i53) -> boolean,
	parent: (self: world, entity: i53) -> i53?,
	contains: (self: world, entity: i53) -> boolean,
	exists: (self: world, entity: i53) -> boolean,
	each: (self: world, id: i53) -> () -> i53,
	children: (self: world, id: i53) -> () -> i53,
	query: (world, ...i53) -> Query<any>,

	added: (world, i53, (e: i53, id: i53, value: any?) -> ()) -> () -> (),
	changed: (world, i53, (e: i53, id: i53, value: any?) -> ()) -> () -> (),
	removed: (world, i53, (e: i53, id: i53) -> ()) -> () -> (),
}

export type World = {
	archetype_edges: Map<number, Map<number, Archetype>>,
	archetype_index: { [string]: Archetype },
	archetypes: { [number]: Archetype },
	component_index: Map<number, ComponentRecord>,
	entity_index: EntityIndex,
	ROOT_ARCHETYPE: Archetype,

	max_component_id: number,
	max_archetype_id: number,

	observable: Map<number, Map<number, { Observer }>>,

	added: (World, number, (e: number, id: number, value: any?, oldarchetype: Archetype) -> ()) -> () -> (),
	removed: (World, number, (e: number, id: number) -> ()) -> () -> (),
	changed: (World, number, (e: number, id: number, value: any?, oldarchetype: Archetype) -> ()) -> () -> (),

	range: (World, range_begin: number, range_end: number?) -> (),
	entity: (World, id: number?) -> number,
	component: (World) -> number,
	target: (World, id: number, relation: number, index: number?) -> number?,
	delete: (World, id: number) -> (),
	add: (World, id: number, component: number) -> (),
	set: (World, id: number, component: number, data: any) -> (),
	cleanup: (World) -> (),
	clear: (World, entity: number) -> (),
	remove: (World, id: number, component: number) -> (),
	get: (World, number, ...number) -> ...any,
	has: (World, number, ...number) -> boolean,
	parent: (World, entity: number) -> number?,
	contains: (World, entity: number) -> boolean,
	exists: (World, entity: number) -> boolean,
	each: (World, id: number) -> () -> number,
	children: (World, id: number) -> () -> number,
	query: (World, ...number) -> Query,
}

export type Record = { archetype: Archetype, row: number, dense: i24 }
export type ComponentRecord = {
	records: { [i24]: number },
	counts: { [i24]: number },
	flags: number,
	size: number,
	on_add: ((entity: number, id: number, value: any?, oldarchetype: Archetype) -> ())?,
	on_change: ((entity: number, id: number, value: any?, oldarchetype: Archetype) -> ())?,
	on_remove: ((entity: number, id: number) -> ())?,
}
export type EntityIndex = {
	dense_array: Map<number, number>,
	sparse_array: Map<i24, Record>,
	alive_count: number,
	max_id: number,
	range_begin: number?,
	range_end: number?,
}

-- stylua: ignore start

local ECS_ENTITY_MASK =       bit32.lshift(1, 24)
local ECS_GENERATION_MASK =   bit32.lshift(1, 16)
local ECS_PAIR_OFFSET = 	                 2^48

local ECS_ID_DELETE =                 	   0b0001
local ECS_ID_IS_TAG =                 	   0b0010
local ECS_ID_IS_EXCLUSIVE =                0b0100
local ECS_ID_MASK =                   	   0b0000

local HI_COMPONENT_ID =                       256
local EcsOnAdd =             HI_COMPONENT_ID +  1
local EcsOnRemove =          HI_COMPONENT_ID +  2
local EcsOnChange =          HI_COMPONENT_ID +  3
local EcsWildcard =          HI_COMPONENT_ID +  4
local EcsChildOf =           HI_COMPONENT_ID +  5
local EcsComponent =         HI_COMPONENT_ID +  6
local EcsOnDelete =          HI_COMPONENT_ID +  7
local EcsOnDeleteTarget =    HI_COMPONENT_ID +  8
local EcsDelete =            HI_COMPONENT_ID +  9
local EcsRemove =            HI_COMPONENT_ID + 10
local EcsName =              HI_COMPONENT_ID + 11
local EcsOnArchetypeCreate = HI_COMPONENT_ID + 12
local EcsOnArchetypeDelete = HI_COMPONENT_ID + 13
local EcsExclusive =         HI_COMPONENT_ID + 14
local EcsRest =              HI_COMPONENT_ID + 15

local NULL_ARRAY = table.freeze({}) :: Column
local NULL = newproxy(false)

local ECS_INTERNAL_ERROR = [[
	This is an internal error, please file a bug report via the following link:

	https://github.com/Ukendio/jecs/issues/new?template=BUG-REPORT.md
]]

local function ecs_assert(condition, msg: string?)
	if not condition then
		error(msg)
	end
end

local ecs_metadata: Map<i53, Map<i53, any>> = {}
local ecs_max_component_id = 0
local ecs_max_tag_id = EcsRest

local function ECS_COMPONENT()
	ecs_max_component_id += 1
	if ecs_max_component_id > HI_COMPONENT_ID then
		error("Too many components")
	end
	return ecs_max_component_id
end

local function ECS_TAG()
	ecs_max_tag_id += 1
	return ecs_max_tag_id
end

local function ECS_META(id: i53, ty: i53, value: any?)
	local bundle = ecs_metadata[id]
	if bundle == nil then
		bundle = {} :: Map<i53, any>
		ecs_metadata[id] = bundle
	end
	bundle[ty] = if value == nil then NULL else value
end

local function ECS_META_RESET()
	ecs_metadata = {}
	ecs_max_component_id = 0
	ecs_max_tag_id = EcsRest
end

local function ECS_COMBINE(id: number, generation: number): i53
	return id + (generation * ECS_ENTITY_MASK)
end

local function ECS_IS_PAIR(e: number): boolean
	return e > ECS_PAIR_OFFSET
end

local function ECS_GENERATION_INC(e: i53): i53
	if e > ECS_ENTITY_MASK then
		local id = e % ECS_ENTITY_MASK
		local generation = e // ECS_ENTITY_MASK

		local next_gen = generation + 1
		if next_gen >= ECS_GENERATION_MASK then
			return id
		end

		return ECS_COMBINE(id, next_gen)
	end
	return ECS_COMBINE(e, 1)
end

local function ECS_ENTITY_T_LO(e: i53): i24
	return e % ECS_ENTITY_MASK
end

local function ECS_ID(e: i53)
	return e % ECS_ENTITY_MASK
end

local function ECS_GENERATION(e: i53)
	return e // ECS_ENTITY_MASK
end

local function ECS_ENTITY_T_HI(e: i53): i24
	return e // ECS_ENTITY_MASK
end

local function ECS_PAIR(pred: i53, obj: i53): i53
	pred %= ECS_ENTITY_MASK
	obj %= ECS_ENTITY_MASK

	return obj + (pred * ECS_ENTITY_MASK) + ECS_PAIR_OFFSET
end

local function ECS_PAIR_FIRST(e: i53): i24
	return (e - ECS_PAIR_OFFSET) // ECS_ENTITY_MASK
end

local function ECS_PAIR_SECOND(e: i53): i24
	return (e - ECS_PAIR_OFFSET) % ECS_ENTITY_MASK
end

local function entity_index_try_get_any(
	entity_index: entityindex,
	entity: i53
): record?
	local r = entity_index.sparse_array[ECS_ID(entity)]

	if not r or r.dense == 0 then
		return nil
	end

	return r
end

local function entity_index_try_get(entity_index: entityindex, entity: i53): record?
	local r = entity_index_try_get_any(entity_index, entity)
	if r then
		local r_dense = r.dense
		if r_dense > entity_index.alive_count then
			return nil
		end
		if entity_index.dense_array[r_dense] ~= entity then
			return nil
		end
	end
	return r
end

local function entity_index_try_get_fast(entity_index: entityindex, entity: i53): record?
	local r = entity_index_try_get_any(entity_index, entity)
	if r then
		local r_dense = r.dense
		-- if r_dense > entity_index.alive_count then
		-- 	return nil
		-- end
		if entity_index.dense_array[r_dense] ~= entity then
			return nil
		end
	end
	return r
end

local function entity_index_is_alive(entity_index: entityindex, entity: i53): boolean
	return entity_index_try_get(entity_index, entity) ~= nil
end

local function entity_index_get_alive(entity_index: entityindex, entity: i53): i53?
	local r = entity_index_try_get_any(entity_index, entity :: number)
	if r then
		return entity_index.dense_array[r.dense]
	end
	return nil
end

local function ecs_get_alive(world: world, entity: i53): i53
	if entity == 0 then
		return 0
	end

	local eindex = world.entity_index

	if entity_index_is_alive(eindex, entity) then
		return entity
	end

	if (entity :: number) > ECS_ENTITY_MASK then
		return 0
	end

	local current = entity_index_get_alive(eindex, entity)
	if not current or not entity_index_is_alive(eindex, current) then
		return 0
	end

	return current
end

local ECS_INTERNAL_ERROR_INCOMPATIBLE_ENTITY = "Entity is outside range"

local function ENTITY_INDEX_NEW_ID(entity_index: entityindex): i53
	local dense_array = entity_index.dense_array
	local alive_count = entity_index.alive_count
	local sparse_array = entity_index.sparse_array
	local max_id = entity_index.max_id

	if alive_count < max_id then
		alive_count += 1
		entity_index.alive_count = alive_count
		local id = dense_array[alive_count]
		return id
	end

	local id = max_id + 1
	local range_end = entity_index.range_end
	ecs_assert(range_end == nil or id < range_end, ECS_INTERNAL_ERROR_INCOMPATIBLE_ENTITY)

	entity_index.max_id = id
	alive_count += 1
	entity_index.alive_count = alive_count
	dense_array[alive_count] = id
	sparse_array[id] = { dense = alive_count } :: record

	return id
end

local function ecs_pair_first(world: world, e: i53)
	local pred = ECS_PAIR_FIRST(e)
	return ecs_get_alive(world, pred)
end

local function ecs_pair_second(world: world, e: i53)
	local obj = ECS_PAIR_SECOND(e)
	return ecs_get_alive(world, obj)
end

local function query_match(query: query, archetype: archetype)
	local columns_map = archetype.columns_map
	local with = query.filter_with

	for _, id in with do
		if not columns_map[id] then
			return false
		end
	end

	local without = query.filter_without
	if without then
		for _, id in without do
			if columns_map[id] then
				return false
			end
		end
	end

	return true
end

local function find_observers(world: world, event: i53, component: i53): { observer }?
	local cache = world.observable[event]
	if not cache then
		return nil
	end
	return cache[component] :: any
end

local function archetype_move(
	entity_index: entityindex,
	entity: i53,
	to: archetype,
	dst_row: i24,
	from: archetype,
	src_row: i24
)
	local src_columns = from.columns
	local dst_entities = to.entities
	local src_entities = from.entities

	local last = #src_entities
	local id_types = from.types
	local columns_map = to.columns_map

	if src_row ~= last then
		-- If the entity is the last row in the archetype then swapping it would be meaningless.

		for i, column in src_columns do
			if column == NULL_ARRAY then
				continue
			end
			-- Retrieves the new column index from the source archetype's record from each component
			-- We have to do this because the columns are tightly packed and indexes may not correspond to each other.
			local dst_column = columns_map[id_types[i]]

			-- Sometimes target column may not exist, e.g. when you remove a component.
			if dst_column and dst_column ~= NULL_ARRAY then
				dst_column[dst_row] = column[src_row]
			end

			-- Swap rempves columns to ensure there are no holes in the archetype.
			column[src_row] = column[last]
			column[last] = nil
		end


		-- Move the entity from the source to the destination archetype.
		-- Because we have swapped columns we now have to update the records
		-- corresponding to the entities' rows that were swapped.

		local e2 = src_entities[last]
		src_entities[src_row] = e2

		local sparse_array = entity_index.sparse_array
		local record2 = sparse_array[ECS_ID(e2)]
		record2.row = src_row
	else
		for i, column in src_columns do
			if column == NULL_ARRAY then
				continue
			end
			-- Retrieves the new column index from the source archetype's record from each component
			-- We have to do this because the columns are tightly packed and indexes may not correspond to each other.
			local dst_column = columns_map[id_types[i]]

			-- Sometimes target column may not exist, e.g. when you remove a component.
			if dst_column and dst_column ~= NULL_ARRAY then
				dst_column[dst_row] = column[src_row]
			end

			column[last] = nil
		end
	end

	src_entities[last] = nil
	dst_entities[dst_row] = entity
end

local function archetype_append(
	entity: i53,
	archetype: archetype
): number
	local entities = archetype.entities
	local length = #entities + 1
	entities[length] = entity
	return length
end

local function new_entity(
	entity: i53,
	record: record,
	archetype: archetype
): record
	local row = archetype_append(entity, archetype)
	record.archetype = archetype
	record.row = row
	return record
end

local function entity_move(
	entity_index: entityindex,
	entity: i53,
	record: record,
	to: archetype
)
	local sourceRow = record.row
	local from = record.archetype
	local dst_row = archetype_append(entity, to)
	archetype_move(entity_index, entity, to, dst_row, from, sourceRow)
	record.archetype = to
	record.row = dst_row
end

local function hash(arr: { i53 }): string
	return table.concat(arr, "_")
end

local function fetch(id: i53, columns_map: { [i53]: Column }, row: number): any
	local column = columns_map[id]

	if not column then
		return nil
	end

	return column[row]
end

local function WORLD_GET(world: world, entity: i53,
	a: i53, b: i53?, c: i53?, d: i53?, e: i53?): ...any
	local record = entity_index_try_get(world.entity_index, entity)
	if not record then
		return nil
	end

	local archetype = record.archetype
	if not archetype then
		return nil
	end

	local columns_map = archetype.columns_map
	local row = record.row

	local va = fetch(a, columns_map, row)

	if not b then
		return va
	elseif not c then
		return va, fetch(b, columns_map, row)
	elseif not d then
		return va, fetch(b, columns_map, row), fetch(c, columns_map, row)
	elseif not e then
		return va, fetch(b, columns_map, row), fetch(c, columns_map, row), fetch(d, columns_map, row)
	else
		error("args exceeded")
	end
end

local function WORLD_HAS(world: world, entity: i53, id: i53): boolean
	local record = entity_index_try_get(world.entity_index, entity)
	if not record then
		return false
	end

	local archetype = record.archetype
	if not archetype then
		return false
	end

	return archetype.columns_map[id] ~= nil
end

local function WORLD_TARGET(world: world, entity: i53, relation: i53, index: number?): i53?
	local entity_index = world.entity_index
	local record = entity_index_try_get(entity_index, entity)
	if not record then
		return nil
	end

	local archetype = record.archetype
	if not archetype then
		return nil
	end

	local r = ECS_PAIR(relation, EcsWildcard)
	local idr = world.component_index[r]

	if not idr then
		return nil
	end

	local archetype_id = archetype.id
	local count = idr.counts[archetype_id]
	if not count then
		return nil
	end

	local nth = index or 0

	if nth >= count then
		return nil
	end

	nth = archetype.types[nth + idr.records[archetype_id]]

	if not nth then
		return nil
	end

	return entity_index_get_alive(entity_index,
	    ECS_PAIR_SECOND(nth :: number))
end

local function ECS_ID_IS_WILDCARD(e: i53): boolean
	local first = ECS_ENTITY_T_HI(e)
	local second = ECS_ENTITY_T_LO(e)
	return first == EcsWildcard or second == EcsWildcard
end

local function id_record_get(world: World, id: Entity): ComponentRecord?
	local component_index = world.component_index
	local idr: ComponentRecord = component_index[id]

	if idr then
		return idr
	end

	return nil
end

local function id_record_create(
	world: world,
	component_index: Map<i53, componentrecord>,
	id: i53
): componentrecord
	local entity_index = world.entity_index
	local flags = ECS_ID_MASK
	local relation = id
	local target = 0
	local is_pair = ECS_IS_PAIR(id :: number)

	local has_delete = false
	local is_exclusive = false

	if is_pair then
		relation = entity_index_get_alive(entity_index, ECS_PAIR_FIRST(id)) :: i53
		ecs_assert(relation and entity_index_is_alive(
			entity_index, relation), ECS_INTERNAL_ERROR)
		target = entity_index_get_alive(entity_index, ECS_PAIR_SECOND(id)) :: i53
		ecs_assert(target and entity_index_is_alive(
			entity_index, target), ECS_INTERNAL_ERROR)

		local cleanup_policy_target = WORLD_TARGET(world, relation, EcsOnDeleteTarget, 0)

		if cleanup_policy_target == EcsDelete then
			has_delete = true
		end

		if WORLD_HAS(world, relation, EcsExclusive) then
			is_exclusive = true
		end
	end

	local cleanup_policy = WORLD_TARGET(world, relation, EcsOnDelete, 0)

	if cleanup_policy == EcsDelete then
		has_delete = true
	end

	local on_add, on_change, on_remove = WORLD_GET(world,
		relation, EcsOnAdd, EcsOnChange, EcsOnRemove)

	local is_tag = not WORLD_HAS(world,
		relation, EcsComponent)

	if is_tag and is_pair then
		is_tag = not WORLD_HAS(world, target, EcsComponent)
	end

	flags = bit32.bor(
		flags,
		if has_delete then ECS_ID_DELETE else 0,
		if is_tag then ECS_ID_IS_TAG else 0,
		if is_exclusive then ECS_ID_IS_EXCLUSIVE else 0
	)

	local idr = {
		size = 0,
		records = {},
		counts = {},
		flags = flags,

		on_add = on_add,
		on_change = on_change,
		on_remove = on_remove,
	} :: componentrecord

	component_index[id] = idr

	return idr
end

local function id_record_ensure(world: world, id: i53): componentrecord
	local component_index = world.component_index
	local idr: componentrecord? = component_index[id]

	if idr then
		return idr
	end

	return id_record_create(world, component_index, id)
end

local function archetype_append_to_records(
	idr: componentrecord,
	archetype_id: number,
	columns_map: { [i53]: Column },
	id: i53,
	index: number,
	column: Column
)
	local idr_records = idr.records
	local idr_counts = idr.counts
	local tr = idr_records[archetype_id]
	if not tr then
		idr_records[archetype_id] = index
		idr_counts[archetype_id] = 1
		columns_map[id] = column
	else
		local max_count = idr_counts[archetype_id] + 1
		idr_counts[archetype_id] = max_count
	end
end

local function archetype_create(world: world, id_types: { i53 }, ty, prev: i53?): archetype
	local archetype_id = (world.max_archetype_id :: number) + 1
	world.max_archetype_id = archetype_id

	local length = #id_types
	local columns = (table.create(length) :: any) :: { Column }

	local columns_map: { [i53]: Column } = {}

	local archetype: archetype = {
		columns = columns,
		columns_map = columns_map,
		entities = {},
		id = archetype_id,
		type = ty,
		types = id_types
	}

	for i, component_id in archetype.types do
		local idr = id_record_ensure(world, component_id)
		idr.size += 1
		local is_tag = bit32.btest(idr.flags, ECS_ID_IS_TAG)
		local column = if is_tag then NULL_ARRAY else {}
		columns[i] = column

		archetype_append_to_records(idr, archetype_id, columns_map, component_id :: number, i, column)

		if ECS_IS_PAIR(component_id) then
			local relation = ECS_PAIR_FIRST(component_id)
			local object = ECS_PAIR_SECOND(component_id)

			local r = ECS_PAIR(relation, EcsWildcard)
			local idr_r = id_record_ensure(world, r)

			idr_r.size += 1
			archetype_append_to_records(idr_r, archetype_id, columns_map, r, i, column)
			local idr_r_wc_pairs = idr_r.wildcard_pairs
			if not idr_r_wc_pairs then
				idr_r_wc_pairs = {} :: {[i53]: componentrecord }
				idr_r.wildcard_pairs = idr_r_wc_pairs
			end
			idr_r_wc_pairs[component_id] = idr

			local t = ECS_PAIR(EcsWildcard, object)
			local idr_t = id_record_ensure(world, t)

			idr_t.size += 1
			archetype_append_to_records(idr_t, archetype_id, columns_map, t, i, column)
		end
	end

	world.archetype_index[ty] = archetype
	world.archetypes[archetype_id] = archetype
	world.archetype_edges[archetype_id] = {} :: Map<i53, archetype>

	for id in columns_map do
		local observer_list = find_observers(world, EcsOnArchetypeCreate, id)
		if not observer_list then
			continue
		end
		for _, observer in observer_list do
			if query_match(observer.query, archetype) then
				observer.callback(archetype::any)
			end
		end
	end

	return archetype
end

local function world_range(world: world, range_begin: number, range_end: number?)
	local entity_index = world.entity_index

	entity_index.range_begin = range_begin
	entity_index.range_end = range_end

	local max_id = entity_index.max_id

	if range_begin > max_id then
		local dense_array = entity_index.dense_array
		local sparse_array = entity_index.sparse_array

		for i = max_id + 1, range_begin do
			dense_array[i] = i
			sparse_array[i] = {
				dense = 0
			} :: record
		end
		entity_index.max_id = range_begin - 1
		entity_index.alive_count = range_begin - 1
	end
end

local function archetype_ensure(world: world, id_types: { i53 }): archetype
	if #id_types < 1 then
		return world.ROOT_ARCHETYPE
	end

	local ty = hash(id_types)
	local archetype = world.archetype_index[ty]
	if archetype then
		return archetype
	end

	return archetype_create(world, id_types, ty)
end

local function find_insert(id_types: { i53 }, toAdd: i53): number
	for i, id in id_types do
		if id == toAdd then
			return -1
		end
		if id > toAdd then
			return i
		end
	end
	return #id_types + 1
end

local function find_archetype_without(
	world: world,
	node: archetype,
	id: i53
): archetype
	local id_types = node.types
	local at = table.find(id_types, id)

	local dst = table.clone(id_types)
	table.remove(dst, at)

	return archetype_ensure(world, dst)
end


local function create_edge_for_remove(
	world: world,
	node: archetype,
	edge: Map<i53, archetype>,
	id: i53
): archetype
	local to = find_archetype_without(world, node, id)
	local edges = world.archetype_edges
	local archetype_id = node.id
	edges[archetype_id][id] = to
	edges[to.id][id] = node
	return to
end

local function archetype_traverse_remove(
	world: world,
	id: i53,
	from: archetype
): archetype
	local edges = world.archetype_edges
	local edge = edges[from.id]

	local to: archetype = edge[id]
	if to == nil then
		to = find_archetype_without(world, from, id)
		edge[id] = to
		edges[to.id][id] = from
	end

	return to
end

local function find_archetype_with(
	world: world,
	id: i53,
	from: archetype
): archetype
	local id_types = from.types
	local dst = table.clone(id_types)

	local at = find_insert(id_types :: { number } , id :: number)

	table.insert(dst, at, id)

	return archetype_ensure(world, dst)
end

local function archetype_traverse_add(
	world: world,
	id: i53,
	from: archetype
): archetype
	from = from or world.ROOT_ARCHETYPE
	if from.columns_map[id] then
		return from
	end
	local edges = world.archetype_edges
	local edge = edges[from.id]

	local to = edge[id]
	if not to then
		to = find_archetype_with(world, id, from)
		edge[id] = to
		edges[to.id][id] = from
	end

	return to
end

local function archetype_fast_delete_last(columns: { Column }, column_count: number)
	for _, column in columns do
		if column ~= NULL_ARRAY then
			column[column_count] = nil
		end
	end
end

local function archetype_fast_delete(columns: { Column }, column_count: number, row: number)
	for _, column in columns do
		if column ~= NULL_ARRAY then
			column[row] = column[column_count]
			column[column_count] = nil
		end
	end
end
local function archetype_delete(world: world, archetype: archetype, row: number)
	local entity_index = world.entity_index
	local columns = archetype.columns
	local entities = archetype.entities
	local column_count = #entities
	local last = #entities
	local move = entities[last]
	-- We assume first that the entity is the last in the archetype

	if row ~= last then
		local record_to_move = entity_index_try_get_any(entity_index, move)
		if record_to_move then
			record_to_move.row = row
		end

		entities[row] = move
	end

	entities[last] = nil :: any

	if row == last then
		archetype_fast_delete_last(columns, column_count)
	else
		archetype_fast_delete(columns, column_count, row)
	end
end


local function archetype_destroy(world: world, archetype: archetype)
	if archetype == world.ROOT_ARCHETYPE then
		return
	end

	local component_index = world.component_index
	local archetype_edges = world.archetype_edges
	local edges = archetype_edges[archetype.id]
	for id, node in edges do
		archetype_edges[node.id][id] = nil
		edges[id] = nil
	end

	local archetype_id = archetype.id
	world.archetypes[archetype_id] = nil :: any
	world.archetype_index[archetype.type] = nil :: any
	local columns_map = archetype.columns_map

	for id in columns_map do
		local idr = component_index[id]
		idr.records[archetype_id] = nil :: any
		idr.counts[archetype_id] = nil
		idr.size -= 1
		if idr.size == 0 then
			component_index[id] = nil :: any
		end
		local observer_list = find_observers(world, EcsOnArchetypeDelete, id)
		if not observer_list then
			continue
		end
		for _, observer in observer_list do
			if query_match(observer.query, archetype) then
				observer.callback(archetype::any)
			end
		end
	end
end

local function NOOP() end

local function query_archetypes(query: query)
	local compatible_archetypes = query.compatible_archetypes
	if not compatible_archetypes then
		compatible_archetypes = {}
		query.compatible_archetypes = compatible_archetypes

		local world = query.world
		local archetypes = world.archetypes

		local component_index = world.component_index

		local idr: componentrecord?
		local with = query.filter_with
		for _, id in with do
			local map = component_index[id]
			if not map then
				continue
			end

			if idr == nil or (map.size :: number) < (idr.size :: number) then
				idr = map
			end
		end

		if idr == nil then
			return compatible_archetypes
		end

		local without = query.filter_without

		for archetype_id in idr.records do
			local archetype = archetypes[archetype_id]
			local columns_map = archetype.columns_map
			local skip = false
			for _, component in with do
				if not columns_map[component] then
					skip = true
					break
				end
			end
			if skip then
				continue
			end
			if without then
				for _, component in without do
					if columns_map[component] then
						skip = true
						break
					end
				end
			end

			if skip then
				continue
			end

			table.insert(compatible_archetypes, archetype)
		end
	end
	return compatible_archetypes
end

local function query_with(query: query, ...: i53)
	local ids = query.ids
	local with = { ... }
	table.move(ids, 1, #ids, #with + 1, with)
	query.filter_with = with
	return query
end

local function query_without(query: query, ...: i53)
	local without = { ... }
	query.filter_without = without
	return query
end

local function query_iter_init(query: QueryInner): () -> (number, ...any)
	local world_query_iter_next

	local compatible_archetypes = query_archetypes(query::any) :: { Archetype }

	local function dedupe_archetypes(list: { Archetype })
		local seen = {}
		local w = 1
		for i = 1, #list do
			local a = list[i]
			if a then
				local id = a.id
				if not seen[id] then
					seen[id] = true
					list[w] = a
					if w ~= i then
						list[i] = nil
					end
					w += 1
				else
					list[i] = nil
				end
			end
		end
	end

	dedupe_archetypes(compatible_archetypes)
	local lastArchetype = 1
	local archetype = compatible_archetypes[1]
	if not archetype then
		return NOOP :: () -> (number, ...any)
	end
	local entities = archetype.entities
	local i = #entities
	local columns_map = archetype.columns_map

	local ids = query.ids
	local A, B, C, D, E, F, G, H, I = unpack(ids :: { Id })
	local a: Column, b: Column, c: Column, d: Column
	local e: Column, f: Column, g: Column, h: Column

	if not A then
		function world_query_iter_next(): any
			local entity = entities[i]
			while entity == nil do
				lastArchetype += 1
				archetype = compatible_archetypes[lastArchetype]
				if not archetype then
					return nil
				end

				entities = archetype.entities
				i = #entities
				if i == 0 then
					continue
				end
				entity = entities[i]
			end
			i -= 1
			return entity
		end
		query.next = world_query_iter_next
		return world_query_iter_next
	elseif not B then
		a = columns_map[A]
	elseif not C then
		a = columns_map[A]
		b = columns_map[B]
	elseif not D then
		a = columns_map[A]
		b = columns_map[B]
		c = columns_map[C]
	elseif not E then
		a = columns_map[A]
		b = columns_map[B]
		c = columns_map[C]
		d = columns_map[D]
	elseif not F then
		a = columns_map[A]
		b = columns_map[B]
		c = columns_map[C]
		d = columns_map[D]
		e = columns_map[E]
	elseif not G then
		a = columns_map[A]
		b = columns_map[B]
		c = columns_map[C]
		d = columns_map[D]
		e = columns_map[E]
		f = columns_map[F]
	elseif not H then
		a = columns_map[A]
		b = columns_map[B]
		c = columns_map[C]
		d = columns_map[D]
		e = columns_map[E]
		f = columns_map[F]
		g = columns_map[G]
	else
		a = columns_map[A]
		b = columns_map[B]
		c = columns_map[C]
		d = columns_map[D]
		e = columns_map[E]
		f = columns_map[F]
		g = columns_map[G]
		h = columns_map[H]
	end

	if not B then
		function world_query_iter_next(): any
			local entity = entities[i]
			while entity == nil do
				lastArchetype += 1
				archetype = compatible_archetypes[lastArchetype]
				if not archetype then
					return nil
				end

				entities = archetype.entities
				i = #entities
				if i == 0 then
					continue
				end
				entity = entities[i]
				columns_map = archetype.columns_map
				a = columns_map[A]
			end

			local row = i
			i -= 1

			return entity, a[row]
		end
	elseif not C then
		function world_query_iter_next(): any
			local entity = entities[i]
			while entity == nil do
				lastArchetype += 1
				archetype = compatible_archetypes[lastArchetype]
				if not archetype then
					return nil
				end

				entities = archetype.entities
				i = #entities
				if i == 0 then
					continue
				end
				entity = entities[i]
				columns_map = archetype.columns_map
				a = columns_map[A]
				b = columns_map[B]
			end

			local row = i
			i -= 1

			return entity, a[row], b[row]
		end
	elseif not D then
		function world_query_iter_next(): any
			local entity = entities[i]
			while entity == nil do
				lastArchetype += 1
				archetype = compatible_archetypes[lastArchetype]
				if not archetype then
					return nil
				end

				entities = archetype.entities
				i = #entities
				if i == 0 then
					continue
				end
				entity = entities[i]
				columns_map = archetype.columns_map
				a = columns_map[A]
				b = columns_map[B]
				c = columns_map[C]
			end

			local row = i
			i -= 1

			return entity, a[row], b[row], c[row]
		end
	elseif not E then
		function world_query_iter_next(): any
			local entity = entities[i]
			while entity == nil do
				lastArchetype += 1
				archetype = compatible_archetypes[lastArchetype]
				if not archetype then
					return nil
				end

				entities = archetype.entities
				i = #entities
				if i == 0 then
					continue
				end
				entity = entities[i]
				columns_map = archetype.columns_map
				a = columns_map[A]
				b = columns_map[B]
				c = columns_map[C]
				d = columns_map[D]
			end

			local row = i
			i -= 1

			return entity, a[row], b[row], c[row], d[row]
		end
	elseif not F then
		function world_query_iter_next(): any
			local entity = entities[i]
			while entity == nil do
				lastArchetype += 1
				archetype = compatible_archetypes[lastArchetype]
				if not archetype then
					return nil
				end

				entities = archetype.entities
				i = #entities
				if i == 0 then
					continue
				end
				entity = entities[i]
				columns_map = archetype.columns_map
				a = columns_map[A]
				b = columns_map[B]
				c = columns_map[C]
				d = columns_map[D]
				e = columns_map[E]
			end

			local row = i
			i -= 1

			return entity, a[row], b[row], c[row], d[row], e[row]
		end
	elseif not G then
		function world_query_iter_next(): any
			local entity = entities[i]
			while entity == nil do
				lastArchetype += 1
				archetype = compatible_archetypes[lastArchetype]
				if not archetype then
					return nil
				end

				entities = archetype.entities
				i = #entities
				if i == 0 then
					continue
				end
				entity = entities[i]
				columns_map = archetype.columns_map
				a = columns_map[A]
				b = columns_map[B]
				c = columns_map[C]
				d = columns_map[D]
				e = columns_map[E]
				f = columns_map[F]
			end

			local row = i
			i -= 1

			return entity, a[row], b[row], c[row], d[row], e[row], f[row]
		end
	elseif not H then
		function world_query_iter_next(): any
			local entity = entities[i]
			while entity == nil do
				lastArchetype += 1
				archetype = compatible_archetypes[lastArchetype]
				if not archetype then
					return nil
				end

				entities = archetype.entities
				i = #entities
				if i == 0 then
					continue
				end
				entity = entities[i]
				columns_map = archetype.columns_map
				a = columns_map[A]
				b = columns_map[B]
				c = columns_map[C]
				d = columns_map[D]
				e = columns_map[E]
				f = columns_map[F]
				g = columns_map[G]
			end

			local row = i
			i -= 1

			return entity, a[row], b[row], c[row], d[row], e[row], f[row], g[row]
		end
	elseif not I then
		function world_query_iter_next(): any
			local entity = entities[i]
			while entity == nil do
				lastArchetype += 1
				archetype = compatible_archetypes[lastArchetype]
				if not archetype then
					return nil
				end

				entities = archetype.entities
				i = #entities
				if i == 0 then
					continue
				end
				entity = entities[i]
				columns_map = archetype.columns_map
				a = columns_map[A]
				b = columns_map[B]
				c = columns_map[C]
				d = columns_map[D]
				e = columns_map[E]
				f = columns_map[F]
				g = columns_map[G]
				h = columns_map[H]
			end

			local row = i
			i -= 1

			return entity, a[row], b[row], c[row], d[row], e[row], f[row], g[row], h[row]
		end
	else
		local output = {}
		local ids_len = #ids
		function world_query_iter_next(): any
			local entity = entities[i]
			while entity == nil do
				lastArchetype += 1
				archetype = compatible_archetypes[lastArchetype]
				if not archetype then
					return nil
				end

				entities = archetype.entities
				i = #entities
				if i == 0 then
					continue
				end
				entity = entities[i]
				columns_map = archetype.columns_map
				a = columns_map[A]
				b = columns_map[B]
				c = columns_map[C]
				d = columns_map[D]
				e = columns_map[E]
				f = columns_map[F]
				g = columns_map[G]
				h = columns_map[H]
			end

			local row = i
			i -= 1

			for i = 9, ids_len do
				output[i - 8] = columns_map[ids[i]::any][row]
			end

			return entity, a[row], b[row], c[row], d[row], e[row], f[row], g[row], h[row], unpack(output)
		end
	end

	query.next = world_query_iter_next
	return world_query_iter_next
end

local function query_iter(query): () -> (number, ...any)
	local query_next = query.next
	if not query_next then
		query_next = query_iter_init(query)
	end
	return query_next
end

local function query_cached(query: QueryInner)
	local ids = query.ids
	local lastArchetype = 1

	local A, B, C, D, E, F, G, H, I = unpack(ids :: { Id })
	if not A then
		A = query.filter_with[1]
	end
	local a: Column, b: Column, c: Column, d: Column
	local e: Column, f: Column, g: Column, h: Column

	local world_query_iter_next
	local entities: { Entity }
	local i: number
	local archetype: Archetype
	local columns_map: { [Id]: Column }
	local archetypes = query_archetypes(query :: any)
	local compatible_archetypes = archetypes :: { Archetype }

	local world = query.world
	-- Only need one observer for EcsArchetypeCreate and EcsArchetypeDelete respectively
	-- because the event will be emitted for all components of that Archetype.
	local observable = world.observable
	local on_create_action = observable[EcsOnArchetypeCreate::any]
	if not on_create_action then
		on_create_action = {} :: Map<Id, { Observer }>
		observable[EcsOnArchetypeCreate::any] = on_create_action
	end
	local query_cache_on_create = on_create_action[A]
	if not query_cache_on_create then
		query_cache_on_create = {}
		on_create_action[A] = query_cache_on_create
	end

	local on_delete_action = observable[EcsOnArchetypeDelete::any]
	if not on_delete_action then
		on_delete_action = {} :: Map<Id, { Observer }>
		observable[EcsOnArchetypeDelete::any] = on_delete_action
	end
	local query_cache_on_delete = on_delete_action[A]
	if not query_cache_on_delete then
		query_cache_on_delete = {}
		on_delete_action[A] = query_cache_on_delete
	end

	local function on_create_callback(archetype)
		table.insert(archetypes, archetype)
	end

	local function on_delete_callback(archetype)
		local i = table.find(archetypes, archetype) :: number
		if i == nil then
			return
		end
		local n = #archetypes
		archetypes[i] = archetypes[n]
		archetypes[n] = nil
	end

	local observer_for_create = { query = query, callback = on_create_callback }
	local observer_for_delete = { query = query, callback = on_delete_callback }

	table.insert(query_cache_on_create, observer_for_create)
	table.insert(query_cache_on_delete, observer_for_delete)

	local function cached_query_iter()
		lastArchetype = 1
		archetype = compatible_archetypes[lastArchetype]
		-- Deduplicate in case restore produced duplicated entries in cached list
		local seen = {}
		local w = 1
		for i = 1, #compatible_archetypes do
			local a = compatible_archetypes[i]
			if a then
				local id = a.id
				if not seen[id] then
					seen[id] = true
					compatible_archetypes[w] = a
					if w ~= i then compatible_archetypes[i] = nil end
					w += 1
				else
					compatible_archetypes[i] = nil
				end
			end
		end
		if not archetype then
			return NOOP
		end
		entities = archetype.entities
		i = #entities
		columns_map = archetype.columns_map
		if not A then
		elseif not B then
			a = columns_map[A]
		elseif not C then
			a = columns_map[A]
			b = columns_map[B]
		elseif not D then
			a = columns_map[A]
			b = columns_map[B]
			c = columns_map[C]
		elseif not E then
			a = columns_map[A]
			b = columns_map[B]
			c = columns_map[C]
			d = columns_map[D]
		elseif not F then
			a = columns_map[A]
			b = columns_map[B]
			c = columns_map[C]
			d = columns_map[D]
			e = columns_map[E]
		elseif not G then
			a = columns_map[A]
			b = columns_map[B]
			c = columns_map[C]
			d = columns_map[D]
			e = columns_map[E]
			f = columns_map[F]
		elseif not H then
			a = columns_map[A]
			b = columns_map[B]
			c = columns_map[C]
			d = columns_map[D]
			e = columns_map[E]
			f = columns_map[F]
			g = columns_map[G]
		else
			a = columns_map[A]
			b = columns_map[B]
			c = columns_map[C]
			d = columns_map[D]
			e = columns_map[E]
			f = columns_map[F]
			g = columns_map[G]
			h = columns_map[H]
		end

		return world_query_iter_next
	end

	if not A then
		function world_query_iter_next(): any
			local entity = entities[i]
			while entity == nil do
				lastArchetype += 1
				archetype = compatible_archetypes[lastArchetype]
				if not archetype then
					return nil
				end

				entities = archetype.entities
				i = #entities
				if i == 0 then
					continue
				end
				entity = entities[i]
			end
			i -= 1
			return entity
		end
	elseif not B then
		function world_query_iter_next(): any
			local entity = entities[i]
			while entity == nil do
				lastArchetype += 1
				archetype = compatible_archetypes[lastArchetype]
				if not archetype then
					return nil
				end

				entities = archetype.entities
				i = #entities
				if i == 0 then
					continue
				end
				entity = entities[i]
				columns_map = archetype.columns_map
				a = columns_map[A]
			end

			local row = i
			i -= 1

			return entity, a[row]
		end
	elseif not C then
		function world_query_iter_next(): any
			local entity = entities[i]
			while entity == nil do
				lastArchetype += 1
				archetype = compatible_archetypes[lastArchetype]
				if not archetype then
					return nil
				end

				entities = archetype.entities
				i = #entities
				if i == 0 then
					continue
				end
				entity = entities[i]
				columns_map = archetype.columns_map
				a = columns_map[A]
				b = columns_map[B]
			end

			local row = i
			i -= 1

			return entity, a[row], b[row]
		end
	elseif not D then
		function world_query_iter_next(): any
			local entity = entities[i]
			while entity == nil do
				lastArchetype += 1
				archetype = compatible_archetypes[lastArchetype]
				if not archetype then
					return nil
				end

				entities = archetype.entities
				i = #entities
				if i == 0 then
					continue
				end
				entity = entities[i]
				columns_map = archetype.columns_map
				a = columns_map[A]
				b = columns_map[B]
				c = columns_map[C]
			end

			local row = i
			i -= 1

			return entity, a[row], b[row], c[row]
		end
	elseif not E then
		function world_query_iter_next(): any
			local entity = entities[i]
			while entity == nil do
				lastArchetype += 1
				archetype = compatible_archetypes[lastArchetype]
				if not archetype then
					return nil
				end

				entities = archetype.entities
				i = #entities
				if i == 0 then
					continue
				end
				entity = entities[i]
				columns_map = archetype.columns_map
				a = columns_map[A]
				b = columns_map[B]
				c = columns_map[C]
				d = columns_map[D]
			end

			local row = i
			i -= 1

			return entity, a[row], b[row], c[row], d[row]
		end
	elseif not F then
		function world_query_iter_next(): any
			local entity = entities[i]
			while entity == nil do
				lastArchetype += 1
				archetype = compatible_archetypes[lastArchetype]
				if not archetype then
					return nil
				end

				entities = archetype.entities
				i = #entities
				if i == 0 then
					continue
				end
				entity = entities[i]
				columns_map = archetype.columns_map
				a = columns_map[A]
				b = columns_map[B]
				c = columns_map[C]
				d = columns_map[D]
				e = columns_map[E]
			end

			local row = i
			i -= 1

			return entity, a[row], b[row], c[row], d[row], e[row]
		end
	elseif not G then
		function world_query_iter_next(): any
			local entity = entities[i]
			while entity == nil do
				lastArchetype += 1
				archetype = compatible_archetypes[lastArchetype]
				if not archetype then
					return nil
				end

				entities = archetype.entities
				i = #entities
				if i == 0 then
					continue
				end
				entity = entities[i]
				columns_map = archetype.columns_map
				a = columns_map[A]
				b = columns_map[B]
				c = columns_map[C]
				d = columns_map[D]
				e = columns_map[E]
				f = columns_map[F]
			end

			local row = i
			i -= 1

			return entity, a[row], b[row], c[row], d[row], e[row], f[row]
		end
	elseif not H then
		function world_query_iter_next(): any
			local entity = entities[i]
			while entity == nil do
				lastArchetype += 1
				archetype = compatible_archetypes[lastArchetype]
				if not archetype then
					return nil
				end

				entities = archetype.entities
				i = #entities
				if i == 0 then
					continue
				end
				entity = entities[i]
				columns_map = archetype.columns_map
				a = columns_map[A]
				b = columns_map[B]
				c = columns_map[C]
				d = columns_map[D]
				e = columns_map[E]
				f = columns_map[F]
				g = columns_map[G]
			end

			local row = i
			i -= 1

			return entity, a[row], b[row], c[row], d[row], e[row], f[row], g[row]
		end
	elseif not I then
		function world_query_iter_next(): any
			local entity = entities[i]
			while entity == nil do
				lastArchetype += 1
				archetype = compatible_archetypes[lastArchetype]
				if not archetype then
					return nil
				end

				entities = archetype.entities
				i = #entities
				if i == 0 then
					continue
				end
				entity = entities[i]
				columns_map = archetype.columns_map
				a = columns_map[A]
				b = columns_map[B]
				c = columns_map[C]
				d = columns_map[D]
				e = columns_map[E]
				f = columns_map[F]
				g = columns_map[G]
				h = columns_map[H]
			end

			local row = i
			i -= 1

			return entity, a[row], b[row], c[row], d[row], e[row], f[row], g[row], h[row]
		end
	else
		local output = {}
		local ids_len = #ids
		function world_query_iter_next(): any
			local entity = entities[i]
			while entity == nil do
				lastArchetype += 1
				archetype = compatible_archetypes[lastArchetype]
				if not archetype then
					return nil
				end

				entities = archetype.entities
				i = #entities
				if i == 0 then
					continue
				end
				entity = entities[i]
				columns_map = archetype.columns_map
				a = columns_map[A]
				b = columns_map[B]
				c = columns_map[C]
				d = columns_map[D]
				e = columns_map[E]
				f = columns_map[F]
				g = columns_map[G]
				h = columns_map[H]
			end

			local row = i
			i -= 1

			for i = 9, ids_len do
				output[i - 8] = columns_map[ids[i]::any][row]
			end

			return entity, a[row], b[row], c[row], d[row], e[row], f[row], g[row], h[row], unpack(output)
		end
	end

	local cached_query = query :: any
	cached_query.archetypes = query_archetypes
	cached_query.__iter = cached_query_iter
	cached_query.iter = cached_query_iter
	setmetatable(cached_query, cached_query)
	return cached_query
end

local Query = {}
Query.__index = Query
Query.__iter = query_iter
Query.iter = query_iter_init
Query.without = query_without
Query.with = query_with
Query.archetypes = query_archetypes
Query.cached = query_cached

local function world_query(world: World, ...)
	local ids = { ... }

	local q = setmetatable({
		ids = ids,
		filter_with = ids,
		world = world,
	}, Query)

	return q
end
local function world_each(world: world, id: i53): () -> i53
	local idr = world.component_index[id]
	if not idr then
		return NOOP :: () -> i53
	end

	local records = idr.records
	local archetypes = world.archetypes
	local archetype_id = next(records, nil) :: number
	local archetype = archetypes[archetype_id]
	if not archetype then
		return NOOP :: () -> i53
	end

	local entities = archetype.entities
	local row = #entities

	return function()
		local entity = entities[row]
		while not entity do
			archetype_id = next(records, archetype_id) :: number
			if not archetype_id then
				return nil :: any
			end
			archetype = archetypes[archetype_id]
			entities = archetype.entities
			row = #entities
			entity = entities[row]
		end
		row -= 1
		return entity
	end
end

local function world_children(world: world, parent: i53)
	return world_each(world, ECS_PAIR(EcsChildOf, parent))
end

local function ecs_bulk_insert(world: world, entity: i53, ids: { i53 }, values: { any })
	local entity_index = world.entity_index
	local r = entity_index_try_get(entity_index, entity)
	if not r then
		return
	end
	local from = r.archetype
	local component_index = world.component_index
	if not from then
		local dst_types = table.clone(ids)
		table.sort(dst_types)

		local to = archetype_ensure(world, dst_types)
		new_entity(entity, r, to)
		local ROOT_ARCHETYPE = world.ROOT_ARCHETYPE
		for i, id in ids do
			local value = values[i]
			local cdr = component_index[id]

			local on_add = cdr.on_add
			if value then
				r.archetype.columns_map[id][r.row] = value
				if on_add then
					on_add(entity, id, value, ROOT_ARCHETYPE)
				end
			else
				if on_add then
					on_add(entity, id, nil, ROOT_ARCHETYPE)
				end
			end
		end
		return
	end

	local dst_types = table.clone(from.types)

	local emplaced: { [number]: boolean } = {}

	for i, id in ids do
	    local at = find_insert(dst_types :: { number }, id :: number)
	    if at == -1 then
			emplaced[i] = true
			continue
	    end

		emplaced[i] = false

	    table.insert(dst_types, at, id)
	end

	local to = archetype_ensure(world, dst_types)

	if from ~= to then
		entity_move(entity_index, entity, r, to)
	end

	for i, set in emplaced do
		local id = ids[i]
		local idr = component_index[id]

		local value = values[i] :: any

		local on_add = idr.on_add

		if value ~= nil then
			local col = r.archetype.columns_map[id]
			if col ~= NULL_ARRAY then
				col[r.row] = value
			end
			local on_change = idr.on_change
			local hook = if set then on_change else on_add
			if hook then
				hook(entity, id, value :: any, from)
			end
		elseif on_add then
			on_add(entity, id, nil, from)
		end
	end
end

local function ecs_bulk_remove(world: world, entity: i53, ids: { i53 })
	local entity_index = world.entity_index
	local r = entity_index_try_get(entity_index, entity)
	if not r then
		return
	end
	local from = r.archetype
	local component_index = world.component_index
	if not from then
		return
	end

	local remove: { [i53]: boolean } = {}

	local columns_map = from.columns_map

	for i, id in ids do
		if not columns_map[id] then
			continue
		end

	    remove[id] = true
		local idr = component_index[id]

		local on_remove = idr.on_remove
		if on_remove then
			on_remove(entity, id)
		end
	end

	local to = r.archetype
	if from ~= to then
		from = to
	end

	local dst_types = table.clone(from.types) :: { i53 }

	for id in remove do
		local at = table.find(dst_types, id)
		table.remove(dst_types, at)
	end

	to = archetype_ensure(world, dst_types)

	if from ~= to then
		entity_move(entity_index, entity, r, to)
	end
end

local function world_new()
	local eindex_dense_array = {} :: { i53 }
	local eindex_sparse_array = {} :: { record }

	local entity_index = {
		dense_array = eindex_dense_array,
		sparse_array = eindex_sparse_array,
		alive_count = 0,
		max_id = 0,
	} :: entityindex

	local component_index = {} :: Map<i53, componentrecord>

	local archetype_index = {} :: { [string]: archetype }
	local archetypes = {} :: Map<i53, archetype>
	local archetype_edges = {} :: { [number]: { [i53]: archetype } }

	local observable = {}

	type Signal = { [i53]: { Listener<any> } }

	local signals = {
		added = {} :: Signal,
		changed = {} :: Signal,
		removed = {} :: Signal
	}

	-- We need to cache the moment the world is registered, that way
	-- `world:component` will not pollute the global registration of components.
	local max_component_id = ecs_max_component_id

	local world = {
		archetype_edges = archetype_edges,

		component_index = component_index,
		entity_index = entity_index,
		ROOT_ARCHETYPE = nil :: any,

		archetypes = archetypes,
		archetype_index = archetype_index,
		max_archetype_id = 0,
		max_component_id = ecs_max_component_id,

		observable = observable,
		signals = signals,
	} :: world


	local function entity_index_new_id(entity_index: entityindex): i53
		local alive_count = entity_index.alive_count
		local max_id = entity_index.max_id

		if alive_count < max_id then
			alive_count += 1
			entity_index.alive_count = alive_count
			local id = eindex_dense_array[alive_count]
			return id
		end

		local id = max_id + 1
		local range_end = entity_index.range_end
		ecs_assert(range_end == nil or id < range_end, ECS_INTERNAL_ERROR_INCOMPATIBLE_ENTITY)

		entity_index.max_id = id
		alive_count += 1
		entity_index.alive_count = alive_count
		eindex_dense_array[alive_count] = id
		eindex_sparse_array[id] = { dense = alive_count } :: record

		return id
	end

	local ROOT_ARCHETYPE = archetype_create(world, {}, "")
	world.ROOT_ARCHETYPE = ROOT_ARCHETYPE

	local function entity_index_try_get_any(entity: i53): record?
		local r = eindex_sparse_array[ECS_ENTITY_T_LO(entity)]
		return r
	end

	local function inner_archetype_move(
		entity: i53,
		to: archetype,
		dst_row: i24,
		from: archetype,
		src_row: i24
	)
		local src_columns = from.columns
		local dst_entities = to.entities
		local src_entities = from.entities

		local last = #src_entities
		local id_types = from.types
		local columns_map = to.columns_map

		if src_row ~= last then
			for i, column in src_columns do
				if column == NULL_ARRAY then
					continue
				end
				local dst_column = columns_map[id_types[i]]

				if dst_column then
					dst_column[dst_row] = column[src_row]
				end

				column[src_row] = column[last]
				column[last] = nil
			end

			local e2 = src_entities[last]
			src_entities[src_row] = e2

			local record2 = eindex_sparse_array[ECS_ENTITY_T_LO(e2)]
			record2.row = src_row
		else
			for i, column in src_columns do
				if column == NULL_ARRAY then
					continue
				end
				local dst_column = columns_map[id_types[i]]
				if dst_column and dst_column ~= NULL_ARRAY then
					dst_column[dst_row] = column[src_row]
				end
				column[last] = nil
			end
		end
		src_entities[last] = nil :: any
		dst_entities[dst_row] = entity
	end

	local function inner_entity_move(
		entity: i53,
		record: record,
		to: archetype
	)
		local sourceRow = record.row
		local from = record.archetype
		local dst_row = archetype_append(entity, to)
		inner_archetype_move(entity, to, dst_row, from, sourceRow)
		record.archetype = to
		record.row = dst_row
	end

	-- local function entity_index_try_get(entity: number): Record?
	-- 	local r = entity_index_try_get_any(entity)
	-- 	if r then
	-- 		local r_dense = r.dense
	-- 		if r_dense > entity_index.alive_count then
	-- 			return nil
	-- 		end
	-- 		if eindex_dense_array[r_dense] ~= entity then
	-- 			return nil
	-- 		end
	-- 	end
	-- 	return r
	-- end

	local function entity_index_try_get_unsafe(entity: i53): record?
		local r = eindex_sparse_array[ECS_ENTITY_T_LO(entity)]
		if r then
			local r_dense = r.dense
			-- if r_dense > entity_index.alive_count then
			-- 	return nil
			-- end
			if eindex_dense_array[r_dense] ~= entity then
				return nil
			end
		end
		return r
	end

	local function exclusive_traverse_add(
		archetype: archetype,
		cr: number,
		id: i53
	)
		local edge = archetype_edges[archetype.id]
		local to = edge[id]
		if not to then
			local dst = table.clone(archetype.types)
			dst[cr] = id
			to = archetype_ensure(world, dst)
			edge[id] = to
		end
		return to
	end

	local function world_set(world: world, entity: i53, id: i53, data): ()
		local record = entity_index_try_get_unsafe(entity)
		if not record then
			return
		end

		local from: archetype = record.archetype
		local src = from or ROOT_ARCHETYPE
		local column = src.columns_map[id]
		if column then
			-- If a value is being stored for what was previously a tag (NULL_ARRAY), upgrade column to real table
			if column == NULL_ARRAY and data ~= nil then
				local new_col = {}
				for i, e in src.entities do
					-- preserve existing tag semantics (no previous data)
					new_col[i] = nil
				end
				src.columns_map[id] = new_col
				-- also patch original columns array entry
				for i, component_id in src.types do
					if component_id == id then
						src.columns[i] = new_col
						break
					end
				end
				column = new_col
			end
			if column ~= NULL_ARRAY then
				local idr = component_index[id]
				column[record.row] = data
				local on_change = idr.on_change
				if on_change then
					on_change(entity, id, data, src)
				end
			end
		else
			local to: archetype
			local idr: componentrecord
			if ECS_IS_PAIR(id) then
				local first = ECS_PAIR_FIRST(id)
				local wc = ECS_PAIR(first, EcsWildcard)
				idr = component_index[wc]

				local edge = archetype_edges[src.id]
				to = edge[id]
				if to == nil then
					if idr and (bit32.btest(idr.flags, ECS_ID_IS_EXCLUSIVE) == true) then
						local cr = idr.records[src.id]
						if cr then
							local on_remove = idr.on_remove
							local id_types = src.types
							if on_remove then
								on_remove(entity, id_types[cr])
								src = record.archetype
								id_types = src.types
								cr = idr.records[src.id]
							end

							to = exclusive_traverse_add(src, cr, id)
						end
					end

					if not to then
						to = find_archetype_with(world, id, src)
						if not idr then
							idr = component_index[wc]
						end
						edge[id] = to
						archetype_edges[(to :: Archetype).id][id] = src
					end
				else
					if bit32.btest(idr.flags, ECS_ID_IS_EXCLUSIVE) then
						local on_remove = idr.on_remove
						if on_remove then
							local cr = idr.records[src.id]
							if cr then
								local id_types = src.types
								on_remove(entity, id_types[cr])
								local arche = record.archetype
								if src ~= arche then
									id_types = arche.types
									cr = idr.records[arche.id]
									to = exclusive_traverse_add(arche, cr, id)
								end
							end
						end
					end
				end
			else
				local edges = archetype_edges
				local edge = edges[src.id]

				to = edge[id]
				if not to then
					to = find_archetype_with(world, id, src)
					edge[id] = to
					edges[to.id][id] = src
				end
				idr = component_index[id]
			end

			if from then
				-- If there was a previous archetype, then the entity needs to move the archetype
				inner_entity_move(entity, record, to)
			else
				new_entity(entity, record, to)
			end

			column = to.columns_map[id]
			if column == NULL_ARRAY and data ~= nil then
				local new_col = {}
				for i, e in to.entities do new_col[i] = nil end
				to.columns_map[id] = new_col
				for i, component_id in to.types do
					if component_id == id then
						to.columns[i] = new_col
						break
					end
				end
				column = new_col
			end
			if column ~= NULL_ARRAY then
				column[record.row] = data
			end

			local on_add = idr.on_add
			if on_add then
				on_add(entity, id, data, src)
			end
		end
	end

	local function world_add(
		world: world,
		entity: i53,
		id: i53
	): ()
		local record = entity_index_try_get_unsafe(entity :: number)
		if not record then
			return
		end

		local from = record.archetype
		local src = from or ROOT_ARCHETYPE
		if src.columns_map[id] then
			return
		end
		local to: archetype
		local idr: componentrecord

		if ECS_IS_PAIR(id) then
			local first = ECS_PAIR_FIRST(id)
			local wc = ECS_PAIR(first, EcsWildcard)
			idr = component_index[wc]

			local edge = archetype_edges[src.id]
			to = edge[id]
			if to == nil then
				if idr and (bit32.btest(idr.flags, ECS_ID_IS_EXCLUSIVE) == true) then
					local cr = idr.records[src.id]
					if cr then
						local on_remove = idr.on_remove
						local id_types = src.types
						if on_remove then
							on_remove(entity, id_types[cr])

							src = record.archetype
							id_types = src.types
							cr = idr.records[src.id]
						end

						to = exclusive_traverse_add(src, cr, id)
					end
				end

				if not to then
					to = find_archetype_with(world, id, src)
					if not idr then
						idr = component_index[wc]
					end
					edge[id] = to
					archetype_edges[(to :: Archetype).id][id] = src
				end
			else
				if bit32.btest(idr.flags, ECS_ID_IS_EXCLUSIVE) then
					local on_remove = idr.on_remove
					if on_remove then
						local cr = idr.records[src.id]
						if cr then
							local id_types = src.types
							on_remove(entity, id_types[cr])
							local arche = record.archetype
							if src ~= arche then
								id_types = arche.types
								cr = idr.records[arche.id]
								to = exclusive_traverse_add(arche, cr, id)
							end
						end
					end
				end
			end
		else
			local edges = archetype_edges
			local edge = edges[src.id]

			to = edge[id]
			if not to then
				to = find_archetype_with(world, id, src)
				edge[id] = to
				edges[to.id][id] = src
			end
			idr = component_index[id]
		end

		if from then
			inner_entity_move(entity, record, to)
		else
			if #to.types > 0 then
				new_entity(entity, record, to)
			end
		end

		local on_add = idr.on_add

		if on_add then
			on_add(entity, id, nil, src)
		end
	end

	local function world_get(world: world, entity: i53,
		a: i53, b: i53?, c: i53?, d: i53?, e: i53?): ...any
		local record = entity_index_try_get_unsafe(entity)
		if not record then
			return nil
		end

		local archetype = record.archetype
		if not archetype then
			return nil
		end

		local columns_map = archetype.columns_map
		local row = record.row

		local va = fetch(a, columns_map, row)

		if not b then
			return va
		elseif not c then
			return va, fetch(b, columns_map, row)
		elseif not d then
			return va, fetch(b, columns_map, row), fetch(c, columns_map, row)
		elseif not e then
			return va, fetch(b, columns_map, row), fetch(c, columns_map, row), fetch(d, columns_map, row)
		else
			error("args exceeded")
		end
	end

	type Listener<T> = (e: i53, id: i53, value: T, oldarchetype: archetype) -> ()

	world.added = function<T>(_: world, component: i53, fn: Listener<T>)
		local listeners = signals.added[component]
		if not listeners then
			listeners = {}
			signals.added[component] = listeners

			local function on_add(entity, id, value, oldarchetype)
				for _, listener in listeners :: { Listener<T> } do
					listener(entity, id, value, oldarchetype)
				end
			end
			local existing_hook = world_get(world, component, EcsOnAdd) :: Listener<T>
			if existing_hook then
				table.insert(listeners, existing_hook)
			end

			local idr_pair = component_index[ECS_PAIR(component, EcsWildcard)]

			if idr_pair then
				for id, cr in idr_pair.wildcard_pairs do
					cr.on_add = on_add
				end
				idr_pair.on_add = on_add
			else
				local idr = component_index[component]
				if idr then
					idr.on_add = on_add
				end
			end
			world_set(world, component, EcsOnAdd, on_add)
		end
		table.insert(listeners, fn)
		return function()
			local n = #listeners
			local i = table.find(listeners, fn)
			listeners[i] = listeners[n]
			listeners[n] = nil
		end
	end

	world.changed = function<T>(
		_: world,
		component: i53,
		fn: Listener<T>
	)
		local listeners = signals.changed[component]
		if not listeners then
			listeners = {}
			signals.changed[component] = listeners
			local function on_change(entity, id, value, oldarchetype)
				for _, listener in listeners :: { Listener<T> }  do
					listener(entity, id, value, oldarchetype)
				end
			end
			local existing_hook = world_get(world, component, EcsOnChange) :: Listener<T>
			if existing_hook then
				table.insert(listeners, existing_hook)
			end

			local idr_pair = component_index[ECS_PAIR(component, EcsWildcard)]

			if idr_pair then
				for _, cr in idr_pair.wildcard_pairs do
					cr.on_change = on_change
				end

				idr_pair.on_change = on_change
			else
				local idr = component_index[component]
				if idr then
					idr.on_change = on_change
				end
			end

			world_set(world, component, EcsOnChange, on_change)
		end
		table.insert(listeners, fn)
		return function()
			local n = #listeners
			local i = table.find(listeners, fn)
			listeners[i] = listeners[n]
			listeners[n] = nil
		end
	end

	world.removed = function<T>(_: world, component: i53, fn: (i53, i53) -> ())
		local listeners = signals.removed[component]
		if not listeners then
			listeners = {}
			signals.removed[component] = listeners
			local function on_remove(entity, id)
				for _, listener in listeners :: { (...any) -> () } do
					listener(entity, id)
				end
			end

			local existing_hook = world_get(world, component, EcsOnRemove) :: Listener<T>
			if existing_hook then
				table.insert(listeners, existing_hook)
			end

			local idr_pair = component_index[ECS_PAIR(component, EcsWildcard)]

			if idr_pair then
				for _, cr in idr_pair.wildcard_pairs do
					cr.on_remove = on_remove
				end

				idr_pair.on_remove = on_remove
			else
				local idr = component_index[component]
				if idr then
					idr.on_remove = on_remove
				end
			end

			world_set(world, component, EcsOnRemove, on_remove)
		end

		table.insert(listeners, fn)

		return function()
			local n = #listeners
			local i = table.find(listeners, fn)
			listeners[i] = listeners[n]
			listeners[n] = nil
		end
	end

	local function world_has(world: World, entity: i53,
		a: i53, b: i53?, c: i53?, d: i53?, e: i53?): boolean

		local record = entity_index_try_get_unsafe(entity)
		if not record then
			return false
		end

		local archetype = record.archetype
		if not archetype then
			return false
		end

		local columns_map = archetype.columns_map

		return columns_map[a] ~= nil and
			(b == nil or columns_map[b] ~= nil) and
			(c == nil or columns_map[c] ~= nil) and
			(d == nil or columns_map[d] ~= nil) and
			(e == nil or error("args exceeded"))
	end

	local function world_target(world: world, entity: i53, relation: i53, index: number?): i53?
		local record = entity_index_try_get_unsafe(entity)
		if not record then
			return nil
		end

		local archetype = record.archetype
		if not archetype then
			return nil
		end

		local r = ECS_PAIR(relation, EcsWildcard)
		local idr = world.component_index[r]

		if not idr then
			return nil
		end

		local archetype_id = archetype.id
		local count = idr.counts[archetype_id]
		if not count then
			return nil
		end

		local nth = index or 0

		if nth >= count then
			return nil
		end

		nth = archetype.types[nth + idr.records[archetype_id]]

		if not nth then
			return nil
		end

		return entity_index_get_alive(world.entity_index,
		    ECS_PAIR_SECOND(nth))
	end

	local function world_parent(world: world, entity: i53): i53?
		return world_target(world, entity, EcsChildOf, 0)
	end

	local function world_entity(world: world, entity: i53?): i53
		if entity then
			local index = ECS_ID(entity)
			local alive_count = entity_index.alive_count
			local r = eindex_sparse_array[index]
			if r then
				local dense = r.dense

				if not dense or r.dense == 0 then
					r.dense = index
					dense = index
					local e_swap = eindex_dense_array[dense]
					local r_swap = entity_index_try_get_any(e_swap) :: record

					r_swap.dense = dense
					alive_count += 1
					entity_index.alive_count = alive_count
					r.dense = alive_count

					eindex_dense_array[dense] = e_swap
					eindex_dense_array[alive_count] = entity
					return entity
				end

				local any = eindex_dense_array[dense]
				if any ~= entity then
					if alive_count <= dense then
						local e_swap = eindex_dense_array[dense]
						local r_swap = entity_index_try_get_any(e_swap) :: record

						r_swap.dense = dense
						alive_count += 1
						entity_index.alive_count = alive_count
						r.dense = alive_count

						eindex_dense_array[dense] = e_swap
						eindex_dense_array[alive_count] = entity
					end
				end

				return entity
			else
				for i = entity_index.max_id + 1, index do
					eindex_sparse_array[i] = { dense = i } :: record
					eindex_dense_array[i] = i
				end
				entity_index.max_id = index

				local e_swap = eindex_dense_array[alive_count]
				local r_swap = eindex_sparse_array[alive_count]
				r_swap.dense = index

				alive_count += 1
				entity_index.alive_count = alive_count

				r = eindex_sparse_array[index]

				r.dense = alive_count

				eindex_sparse_array[index] = r

				eindex_dense_array[index] = e_swap
				eindex_dense_array[alive_count] = entity

				return entity
			end
		end
		return entity_index_new_id(entity_index)
	end

	local function world_remove(world: world, entity: i53, id: i53)
		local record = entity_index_try_get_unsafe(entity)
		if not record then
			return
		end
		local from = record.archetype

		if not from then
			return
		end

		if from.columns_map[id] then
			local idr = world.component_index[id]
			local on_remove = idr.on_remove

			if on_remove then
				on_remove(entity, id)
			end

			local to = archetype_traverse_remove(world, id, record.archetype)

			inner_entity_move(entity, record, to)
		end
	end

	local function world_delete(world: world, entity: i53)
		local record = entity_index_try_get_unsafe(entity)
		if not record then
			return
		end

		local archetype = record.archetype

		if archetype then
			for _, id in archetype.types do
				local idr = component_index[id]
				local on_remove = idr.on_remove
				if on_remove then
					on_remove(entity, id)
				end
			end
			archetype_delete(world, record.archetype, record.row)
		end

		local component_index = world.component_index
		local archetypes = world.archetypes
		local tgt = ECS_PAIR(EcsWildcard, entity::number)
		local rel = ECS_PAIR(entity::number, EcsWildcard)

		local idr_t = component_index[tgt]
		local idr = component_index[entity::number]
		local idr_r = component_index[rel]

		if idr then
			local flags = idr.flags
			if (bit32.btest(flags, ECS_ID_DELETE) == true) then
				for archetype_id in idr.records do
					local idr_archetype = archetypes[archetype_id]

					local entities = idr_archetype.entities
					local n = #entities
					for i = n, 1, -1 do
						world_delete(world, entities[i])
					end

					archetype_destroy(world, idr_archetype)
				end
			else
				local on_remove = idr.on_remove
				if on_remove then
					for archetype_id in idr.records do
						local idr_archetype = archetypes[archetype_id]
						local to = archetype_traverse_remove(world, entity, idr_archetype)
						local entities = idr_archetype.entities
						local n = #entities
						for i = n, 1, -1 do
							local e = entities[i]
							on_remove(e, entity)
							local r = eindex_sparse_array[ECS_ID(e :: number)]
							local from = r.archetype
							if from ~= idr_archetype then
								-- unfortunately the on_remove hook allows a window where `e` can have changed archetype
								-- this is hypothetically not that expensive of an operation anyways
								to = archetype_traverse_remove(world, entity, from)
							end
							inner_entity_move(e, r, to)
						end

						archetype_destroy(world, idr_archetype)
					end
				else
					for archetype_id in idr.records do
						local idr_archetype = archetypes[archetype_id]
						local to = archetype_traverse_remove(world, entity, idr_archetype)
						local entities = idr_archetype.entities
						local n = #entities
						for i = n, 1, -1 do
							local e = entities[i]
							entity_move(entity_index, e, eindex_sparse_array[ECS_ID(e :: number)], to)
						end

						archetype_destroy(world, idr_archetype)
					end
				end
			end
		end
		if idr_t then
			local archetype_ids = idr_t.records
			for archetype_id in archetype_ids do
				local idr_t_archetype = archetypes[archetype_id]
				local idr_t_types = idr_t_archetype.types
				local entities = idr_t_archetype.entities

				for _, id in idr_t_types do
					if not ECS_IS_PAIR(id) then
						continue
					end
					local object = entity_index_get_alive(
					    entity_index, ECS_PAIR_SECOND(id))
					if object ~= entity then
						continue
					end
					local id_record = component_index[id]
					local flags = id_record.flags
					local flags_delete_mask = bit32.btest(flags, ECS_ID_DELETE)
					if flags_delete_mask then
						for i = #entities, 1, -1 do
							local child = entities[i]
							world_delete(world, child)
						end
						break
					else
						local on_remove = id_record.on_remove

						for i = #entities, 1, -1 do
							local child = entities[i]
							if on_remove then
								on_remove(child, id)
							end

							local r = entity_index_try_get_unsafe(child) :: record
							local to = archetype_traverse_remove(world, id, r.archetype)
							inner_entity_move(child, r, to)
						end
					end
				end
			end

			for archetype_id in archetype_ids do
				archetype_destroy(world, archetypes[archetype_id])
			end
		end

		if idr_r then
			local archetype_ids = idr_r.records
			local flags = idr_r.flags
			local has_delete_policy = bit32.btest(flags, ECS_ID_DELETE)
			if has_delete_policy then
				for archetype_id in archetype_ids do
					local idr_r_archetype = archetypes[archetype_id]
					local entities = idr_r_archetype.entities
					local n = #entities
					for i = n, 1, -1 do
						world_delete(world, entities[i])
					end
					archetype_destroy(world, idr_r_archetype)
				end
			else
				local counts = idr_r.counts
				local records = idr_r.records
				for archetype_id in archetype_ids do
					local idr_r_archetype = archetypes[archetype_id]
					local node = idr_r_archetype
					local entities = idr_r_archetype.entities
					local tr = records[archetype_id]
					local tr_count = counts[archetype_id]
					local types = idr_r_archetype.types
					for i = tr, tr + tr_count - 1 do
						local id = types[i]
						node = archetype_traverse_remove(world, id, node)
						local on_remove = component_index[id].on_remove
						if on_remove then
							for _, entity in entities do
								on_remove(entity, id)
							end
						end
					end

					for i = #entities, 1, -1 do
						local e = entities[i]
						local r = entity_index_try_get_unsafe(e) :: record
						inner_entity_move(e, r, node)
					end
				end

				for archetype_id in archetype_ids do
					archetype_destroy(world, archetypes[archetype_id])
				end
			end
		end


		local dense = record.dense
		local i_swap = entity_index.alive_count
		entity_index.alive_count = i_swap - 1

		local e_swap = eindex_dense_array[i_swap]
		local r_swap = entity_index_try_get_any(e_swap) :: record
		r_swap.dense = dense
		record.archetype = nil :: any
		record.row = nil :: any
		record.dense = i_swap

		eindex_dense_array[dense] = e_swap
		eindex_dense_array[i_swap] = ECS_GENERATION_INC(entity)
	end

	local function world_clear(world: world, entity: i53)
		local record = entity_index_try_get_unsafe(entity)
		if not record then
			return
		end

		local archetype = record.archetype
		for _, id in archetype.types do
			local idr = component_index[id]
			local on_remove = idr.on_remove
			if on_remove then
				on_remove(entity, id)
			end
		end
		archetype_delete(world, record.archetype, record.row)
		record.archetype = nil :: any
		record.row = nil :: any
	end

	local function world_exists(world: world, entity: i53): boolean
		return entity_index_try_get_any(entity) ~= nil
	end

	local function world_contains(world: world, entity: i53): boolean
		return entity_index_is_alive(entity_index, entity)
	end

	local function world_cleanup(world: world)
		for _, archetype in archetypes do
			if #archetype.entities == 0 then
				archetype_destroy(world, archetype)
			end
		end

		local new_archetypes = {}
		local new_archetype_map = {}

		for index, archetype in archetypes do
			new_archetypes[index] = archetype
			new_archetype_map[archetype.type] = archetype
		end

		archetypes = new_archetypes
		archetype_index = new_archetype_map

		world.archetypes = new_archetypes
		world.archetype_index = new_archetype_map
	end

	local function world_component(world: world): i53
		max_component_id += 1
		if max_component_id > HI_COMPONENT_ID then
			-- IDs are partitioned into ranges because component IDs are not nominal,
			-- so it needs to error when IDs intersect into the entity range.
			error("Too many components, consider using world:entity() instead to create components.")
		end
		world.max_component_id = max_component_id
		world_add(world, max_component_id, EcsComponent)

		return max_component_id
	end

	world.entity = world_entity
	world.query = world_query :: any
	world.remove = world_remove
	world.clear = world_clear
	-- world.purge = world_purge
	world.delete = world_delete
	world.component = world_component
	world.add = world_add
	world.set = world_set
	world.get = world_get :: any
	world.has = world_has :: any
	world.target = world_target
	world.parent = world_parent
	world.contains = world_contains
	world.exists = world_exists
	world.cleanup = world_cleanup
	world.each = world_each
	world.children = world_children
	world.range = world_range

	for i = 1, EcsRest do
		entity_index_new_id(entity_index)
	end

	for i = 1, max_component_id do
		world_add(world, i, EcsComponent)
	end

	world_add(world, EcsName, EcsComponent)
	world_add(world, EcsOnChange, EcsComponent)
	world_add(world, EcsOnAdd, EcsComponent)
	world_add(world, EcsOnRemove, EcsComponent)
	world_add(world, EcsWildcard, EcsComponent)
	world_add(world, EcsRest, EcsComponent)

	world_set(world, EcsOnAdd, EcsName, "jecs.OnAdd")
	world_set(world, EcsOnRemove, EcsName, "jecs.OnRemove")
	world_set(world, EcsOnChange, EcsName, "jecs.OnChange")
	world_set(world, EcsWildcard, EcsName, "jecs.Wildcard")
	world_set(world, EcsChildOf, EcsName, "jecs.ChildOf")
	world_set(world, EcsComponent, EcsName, "jecs.Component")

	world_set(world, EcsOnDelete, EcsName, "jecs.OnDelete")
	world_set(world, EcsOnDeleteTarget, EcsName, "jecs.OnDeleteTarget")

	world_set(world, EcsDelete, EcsName, "jecs.Delete")
	world_set(world, EcsRemove, EcsName, "jecs.Remove")
	world_set(world, EcsName, EcsName, "jecs.Name")
	world_set(world, EcsRest, EcsRest, "jecs.Rest")

	world_add(world, EcsChildOf, ECS_PAIR(EcsOnDeleteTarget, EcsDelete))
	world_add(world, EcsChildOf, EcsExclusive)

	world_add(world, EcsOnDelete, EcsExclusive)
	world_add(world, EcsOnDeleteTarget, EcsExclusive)

	for i = EcsRest + 1, ecs_max_tag_id do
		entity_index_new_id(entity_index)
	end

	for i, bundle in ecs_metadata do
		for ty, value in bundle do
			if value == NULL then
				world_add(world, i, ty)
			else
				world_set(world, i, ty, value)
			end
		end
	end

	return world
end

-- type function ecs_id_t(ty)
-- 	local __T = ty:readproperty(types.singleton("__T"))
-- 	if not __T then
-- 		return ty:readproperty(types.singleton("__jecs_pair_value"))
-- 	end
-- 	return __T
-- end

-- type function ecs_pair_t(first, second)
-- 	if ecs_id_t(first):is("nil") then
-- 		return second
-- 	else
-- 		return first
-- 	end
-- end
--

local function ecs_is_tag(world: world, entity: i53): boolean
	local idr = world.component_index[entity]
	if idr then
		return bit32.btest(idr.flags, ECS_ID_IS_TAG)
	end
	return not WORLD_HAS(world, entity, EcsComponent)
end

local function ecs_entity_record(world: world, entity: i53)
	return entity_index_try_get(world.entity_index, entity)
end

return {
	world = world_new :: () -> World,
	World = {
		new = world_new
	},

	snapshot = function(world)
		local function deep_copy(v)
			if type(v) ~= "table" then return v end
			local t = {}
			for k, vv in v do t[k] = deep_copy(vv) end
			return t
		end
		local entity_index = world.entity_index
		local archetypes = world.archetypes
		local component_index = world.component_index

		local s_entity_index = {
			alive_count = entity_index.alive_count,
			max_id = entity_index.max_id,
			dense_array = table.clone(entity_index.dense_array),
			sparse_array = {},
			range_begin = entity_index.range_begin,
			range_end = entity_index.range_end,
		}
		for id, record in entity_index.sparse_array do
			if record then
				local a = record.archetype and record.archetype.id or nil
				s_entity_index.sparse_array[id] = { archetype = a, row = record.row, dense = record.dense }
			end
		end

		local s_archetypes = {}
		for aid, a in archetypes do
			local cols_copy = {}
			for i, col in a.columns do
				if col == NULL_ARRAY then
					cols_copy[i] = NULL_ARRAY
				else
					local new_col = {}
					for r, v in col do new_col[r] = deep_copy(v) end
					cols_copy[i] = new_col
				end
			end
			local edge_map = world.archetype_edges[aid]
			local edges_copy = {}
			for cid, to_a in edge_map do edges_copy[cid] = to_a.id end
			s_archetypes[aid] = {
				id = a.id,
				type = a.type,
				types = table.clone(a.types),
				entities = table.clone(a.entities),
				columns = cols_copy,
				edges = edges_copy,
			}
		end

		local s_components = {}
		for cid, cr in component_index do
			local records_copy, counts_copy = {}, {}
			for aid, idx in cr.records do records_copy[aid] = idx end
			for aid, cnt in cr.counts do counts_copy[aid] = cnt end
			local wc_pairs = {}
			local wcp = cr.wildcard_pairs
			if wcp then for pid in wcp do wc_pairs[pid] = true end end
			s_components[cid] = {
				size = cr.size,
				flags = cr.flags,
				records = records_copy,
				counts = counts_copy,
				wildcard_pairs = wc_pairs,
				hooks = { on_add = cr.on_add, on_change = cr.on_change, on_remove = cr.on_remove },
			}
		end

		return {
			version = 4,
			entity_index = s_entity_index,
			archetypes = s_archetypes,
			components = s_components,
			max_archetype_id = world.max_archetype_id,
			max_component_id = world.max_component_id,
		}
	end,
	restore = function(world, snapshot)
		assert(snapshot.version == 4, "unsupported snapshot version")
		-- IMPORTANT: mutate in-place; reuse archetype objects to preserve references captured by cached queries.
		local archetype_edges = world.archetype_edges
		local archetypes = world.archetypes
		local archetype_index = world.archetype_index
		local component_index = world.component_index

		-- 1. Clear existing component records
		for k in component_index do component_index[k] = nil end
		-- 2. Rebuild component records
		for cid, cr in snapshot.components do
			component_index[cid] = {
				size = cr.size,
				flags = cr.flags,
				records = table.clone(cr.records),
				counts = table.clone(cr.counts),
				wildcard_pairs = {},
				on_add = cr.hooks.on_add,
				on_change = cr.hooks.on_change,
				on_remove = cr.hooks.on_remove,
			}
		end
		for cid, cr in snapshot.components do
			local rec = component_index[cid]
			for pid in cr.wildcard_pairs do rec.wildcard_pairs[pid] = component_index[pid] end
		end

		-- 3. Reuse or create archetype objects, but don't replace tables for existing ones
		-- Build a set of snapshot archetype ids
		local snap_ids = {}
		for aid in snapshot.archetypes do snap_ids[aid] = true end

		-- Remove archetypes not present in snapshot (except ROOT which should always exist in snapshot too)
		for aid, a in archetypes do
			if not snap_ids[aid] then
				archetypes[aid] = nil
				archetype_edges[aid] = nil
				archetype_index[a.type] = nil
			end
		end

		-- Ensure edges table exists for each archetype id we will restore
		for aid in snapshot.archetypes do
			local edges = archetype_edges[aid]
			if not edges then
				archetype_edges[aid] = {}
			else
				for k in edges do edges[k] = nil end
			end
		end

		-- Rebuild / mutate archetypes
		for aid, a in snapshot.archetypes do
			local existing = archetypes[aid]
			local columns_map = {}
			if existing then
				-- mutate existing archetype (preserve object identity)
				existing.type = a.type
				-- mutate types array
				for i in existing.types do existing.types[i] = nil end
				for i, v in a.types do existing.types[i] = v end
				-- mutate entities array
				for i in existing.entities do existing.entities[i] = nil end
				for i, v in a.entities do existing.entities[i] = v end
				-- mutate columns array and their contents
				local cols = existing.columns
				for i, col in a.columns do
					local target_col = cols[i]
					if col == NULL_ARRAY then
						cols[i] = NULL_ARRAY
					else
						if not target_col or target_col == NULL_ARRAY then
							target_col = {}
							cols[i] = target_col
						else
							for k in target_col do target_col[k] = nil end
						end
						for r, v in col do target_col[r] = v end
					end
				end
				-- remove extra columns if any
				for i = #a.columns + 1, #cols do cols[i] = nil end
				for i, id in existing.types do
					local col = existing.columns[i]
					columns_map[id] = col
					if ECS_IS_PAIR(id) then
						local relation = ECS_PAIR_FIRST(id)
						local object = ECS_PAIR_SECOND(id)
						-- wildcard relation variant
						local wc_rel = ECS_PAIR(relation, EcsWildcard)
						columns_map[wc_rel] = col
						local wc_obj = ECS_PAIR(EcsWildcard, object)
						columns_map[wc_obj] = col
					end
				end
				existing.columns_map = columns_map
			else
				-- create new archetype object (wasn't in prior world)
				local new_columns = {}
				for i, col in a.columns do
					if col == NULL_ARRAY then
						new_columns[i] = NULL_ARRAY
					else
						local copy = {}
						for r, v in col do copy[r] = v end
						new_columns[i] = copy
					end
				end
				existing = {
					id = a.id,
					type = a.type,
					types = table.clone(a.types),
					entities = table.clone(a.entities),
					columns = new_columns,
					columns_map = columns_map,
				}
				archetypes[aid] = existing
			end
			archetype_index[a.type] = existing
			for i, id in existing.types do
				local col = existing.columns[i]
				columns_map[id] = col
				if ECS_IS_PAIR(id) then
					local relation = ECS_PAIR_FIRST(id)
					local object = ECS_PAIR_SECOND(id)
					local wc_rel = ECS_PAIR(relation, EcsWildcard)
					columns_map[wc_rel] = col
					local wc_obj = ECS_PAIR(EcsWildcard, object)
					columns_map[wc_obj] = col
				end
			end
		end

		-- Rebuild edges
		for aid, a in snapshot.archetypes do
			local target_edges = archetype_edges[aid]
			for cid, to_id in a.edges do
				local to_archetype = archetypes[to_id]
				if to_archetype then
					target_edges[cid] = to_archetype
				end
			end
		end

		-- 4. Restore entity index in-place
		local s_eindex = snapshot.entity_index
		local eindex = world.entity_index
		eindex.alive_count = s_eindex.alive_count
		eindex.max_id = s_eindex.max_id
		eindex.range_begin = s_eindex.range_begin
		eindex.range_end = s_eindex.range_end
		local dense = eindex.dense_array
		for i in dense do dense[i] = nil end
		for i, v in s_eindex.dense_array do dense[i] = v end
		local sparse = eindex.sparse_array
		for k in sparse do sparse[k] = nil end
		for id, r in s_eindex.sparse_array do
			if r then
				local a = r.archetype and archetypes[r.archetype] or nil
				sparse[id] = { archetype = a, row = r.row, dense = r.dense }
			end
		end

		world.max_archetype_id = snapshot.max_archetype_id
		world.max_component_id = snapshot.max_component_id
	end,
	component = ECS_COMPONENT,
	tag = ECS_TAG,
	meta = ECS_META,
	is_tag = ecs_is_tag,

	OnAdd = EcsOnAdd,
	OnRemove = EcsOnRemove,
	OnChange = EcsOnChange,
	ChildOf = EcsChildOf,
	Component = EcsComponent,
	Wildcard = EcsWildcard,
	w = EcsWildcard,
	OnDelete = EcsOnDelete,
	OnDeleteTarget = EcsOnDeleteTarget,
	Delete = EcsDelete,
	Remove = EcsRemove,
	Name = EcsName,
	Exclusive = EcsExclusive,
	ArchetypeCreate = EcsOnArchetypeCreate,
	ArchetypeDelete = EcsOnArchetypeDelete,
	Rest = EcsRest,

	pair = ECS_PAIR,
	IS_PAIR = ECS_IS_PAIR,
	ECS_PAIR_FIRST = ECS_PAIR_FIRST,
	ECS_PAIR_SECOND = ECS_PAIR_SECOND,
	pair_first = ecs_pair_first,
	pair_second = ecs_pair_second,
	entity_index_get_alive = entity_index_get_alive,

	archetype_append_to_records = archetype_append_to_records,
	id_record_ensure = id_record_ensure,
	component_record = id_record_get,
	record = ecs_entity_record,

	archetype_create = archetype_create,
	archetype_ensure = archetype_ensure,
	find_insert = find_insert,
	find_archetype_with = find_archetype_with,
	find_archetype_without = find_archetype_without,
	create_edge_for_remove = create_edge_for_remove,
	archetype_traverse_add = archetype_traverse_add,
	archetype_traverse_remove = archetype_traverse_remove,
	bulk_insert = ecs_bulk_insert,
	bulk_remove = ecs_bulk_remove,

	entity_move = entity_move,

	entity_index_try_get = entity_index_try_get,
	entity_index_try_get_fast = entity_index_try_get_fast,
	entity_index_try_get_any = entity_index_try_get_any,
	entity_index_is_alive = entity_index_is_alive,
	entity_index_new_id = ENTITY_INDEX_NEW_ID,

	Query = Query,

	query_iter = query_iter,
	query_iter_init = query_iter_init,
	query_with = query_with,
	query_without = query_without,
	query_archetypes = query_archetypes,
	query_match = query_match,

	find_observers = find_observers,

	ECS_ID = ECS_ENTITY_T_LO,
	ECS_GENERATION_INC = ECS_GENERATION_INC,
	ECS_GENERATION = ECS_GENERATION,
	ECS_ID_IS_WILDCARD = ECS_ID_IS_WILDCARD,
	ECS_ID_IS_EXCLUSIVE = ECS_ID_IS_EXCLUSIVE,
	ECS_ID_DELETE = ECS_ID_DELETE,
	ECS_META_RESET = ECS_META_RESET,
	ECS_COMBINE = ECS_COMBINE,
	ECS_ENTITY_MASK = ECS_ENTITY_MASK,
}
