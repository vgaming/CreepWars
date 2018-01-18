#!/bin/bash -eu

luacheck lua/*.lua --globals wesnoth --globals creepwars --globals creepwars_unit_can_advance
