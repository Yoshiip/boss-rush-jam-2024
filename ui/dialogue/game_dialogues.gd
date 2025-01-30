class_name GameDialogues
extends Node

static var TEST_DIALOGUE: Array[String] = [
	"Hello",
	"o:Hello",
	"This is a test dialogue",
	"The end!!",
	"o:Goodbye"
]

# o: other
# i: interval (wait)
# #: event
static var INTRO_DIALOGUE: Array[String] = [
	"Sigh... I shouldn’t have gambled after drinking last night, I lost everything...",
	"How am I supposed to pay 923 701 in a week?",
	"i:2",
	"o:Ring ring..",
	"Hello, who’s calling?",
	"o:This is Mr. K from Cosmicapital.",
	"Cosmicapital? You control half the galaxy. What do you need from me?",
	"o:We have an offer for you. You may find it…quite lucrative.",
	"I’m listening.",
	"o:As part of our mining and reconstruction efforts, we employ a small team of starship pilots to destroy Void Things that interfere with our efforts.",
	"o:You have made a name for yourself as a skilled pilot. We need talent like yours.",
	"What’s in it for me?",
	"o:Benefits. Monetary. The payout is 230972 per mission. We provide you with a best-in-class starship. No risk.",
	"That sounds too good to be true. I need to think about it.",
	"o:You have 3 seconds to decide.",
	"…I’m in.",
	"o:Great.",
	"When do i start?",
	"o:Right now, we look forward to seeing you at our headquarters.",
	"i:2",
	"#ship",
	"i:1",
	"o:This is your ship for these missions. It's state-of-the-art and will be your perfect tool for fighting Void Things.",
	"o:It's highly modular. Take a look at it and choose how you want to modify it.",
	"o:When you're ready, let me know and I'll send you on your first mission.",
]
