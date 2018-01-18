https://github.com/mpeterv/luacheck


```
luacheck ./*.lua --globals wesnoth --globals creepwars --globals creepwars_unit_can_advance --globals creepwars_shop_result --globals creepwars_unit_at_shop --globals format_as_json --globals print_as_json
```

```
find -name '*.lua' -print0 | xargs -0 -I '{}' luacheck '{}' --globals wesnoth --globals creepwars --globals creepwars_unit_can_advance --globals creepwars_shop_result --globals creepwars_unit_at_shop --globals format_as_json --globals print_as_json
```
