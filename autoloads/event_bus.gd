extends Node

@warning_ignore_start("unused_signal")
signal pause_opened
signal pause_closed
signal gun_fired
signal music_looped
signal pause_queued
signal color_started(colors: Gunshot.GunColor)
signal color_ended(colors: Gunshot.GunColor)
signal game_started
@warning_ignore_restore("unused_signal")
