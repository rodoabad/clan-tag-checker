#########################################################################################################
# SCRIPT NAME: Clan Tag Checker
# VERSION: 1.0
# AUTHOR: rodoabad
# DESCRIPTION: This is a simple TCL script that I wrote for my gaming community awhile back in 2010
#			   when I was still in college. When a user gets voiced, the bot checks if the user has a clan tag or
#			   not. If the user doesn't have a clan tag it devoices them.
# CREDITS:
# hwk (#tcl @ IRC.Undernet.Org)
# SnoopyChit (#tcl @ IRC.Undernet.Org)
# sleeples (#eggtcl @ IRC.EfNet.Org)
#########################################################################################################

#########################################################################################################
# SETTINGS
#########################################################################################################

# Channel to check
set tag(chan) "#channel"

# Tag to check
set tag(prefix) {\[clantag\]*}

# Message to user
set tag(reason) "Please tag up properly, thanks."

#########################################################################################################
# CODE 
#########################################################################################################

# On mode
bind mode -|- * on_voice
proc on_voice { nick uhost hand chan mode {target ""}} {
	global tag

	if {![string equal -nocase $chan $tag(chan)] || ![botisop $chan]} { return }
	if {[string equal -nocase "+v" $mode] && ![string match -nocase "$tag(prefix)" $target]} {
		pushmode $chan -v $target
		putquick "PRIVMSG $target :$tag(reason)"
	}
}

# On nick change
bind nick -|- * nick_ch
proc nick_ch { nick uhost handle chan newnick } {
	global tag

	if {([string equal -nocase $chan $tag(chan)] && [botisop $chan] && [isvoice $newnick $chan]) && ![string match -nocase "$tag(prefix)" $newnick]} {
		pushmode $chan -v $newnick
		putquick "NOTICE $newnick :$tag(reason)"
	}
}

putlog "Clan Tag Checker v1.0 by rodoabad"