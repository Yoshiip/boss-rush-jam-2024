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
	"How am I supposed to pay $923,701 in a week?",
	"o:Ring ring...",
	"Who is this? How did you access my communications system?",
	"o: Congratulations, Mr. Vander. You’ve been selected for an exclusive employment opportunity with CosmiCapital Corporation. You start today.",
	"What? I didn’t apply for anything.",
	"o:No need. We recognize talent. You’re a skilled pilot—just one with unfortunate financial habits. We’d like to help.",
	"You just want to “help”? Right. Let’s hear the catch.",
	"o:It’s simple. Resource extraction.",
	"I’m a fighter pilot, not a miner.",
	"o:These resources are… unconventional.",
	"…Go on.",
	"o: At first, we thought we had discovered alien spacecraft. But alas, we remain alone in this universe.",
	"o:Instead, we found something else—massive entities of flesh and ore, drifting through the void. Void Things, we call them.",
	"...",
	"o:They aren’t aggressive unless provoked. Your job is to provoke them. Terminate them. You’ll be paid handsomely per kill. We’ll even provide you with a top of the line fighter ship.",
	"This is too sketchy. I’m out.",
	"o:Mr. Vander, I think you misunderstand. This is not a job offer. You are already a CosmiCapital employee.",
	"What are you talking about?",
	"o:In the interest of assisting you, we purchased all of your debt. Work hard and you should be able to pay it off in no time. ",
	"I really don’t have a choice, do I?",
	"o:Welcome to the CosmiCorp family, Mr. Vander.",
]

static var MISSIONS := [
	[
		"#switch_to_chief",
		"This is practically robbery!",
		"o:These fees are standard across all CosmiCapital operations. Your safety is our priority.",
		"Safety? I could have died. And all for basically nothing!",
		"o:Then it is fortunate you did not. Chin up! Future payouts will be higher. Continue to work hard, and you’ll be debt-free in no time at all.",
	],
	[
		"#switch_to_mysterious",
		"o:I see you've been snooping around... Looking for information?",
		"I don't know what you mean. Who is this?",
		"o:Relax, I'm on your side. Just keep quiet about this conversation.",
		"What do you want?",
		"o:You want to know why the decontamination fee is so high, don’t you?",
		"?",
		"o:Every time a ship returns from an encounter with one of those things, it's completely destroyed—burned and melted down. After they extract you from it, of course.",
		"That doesn’t make sense. They said—",
		"o:They said a lot of things. They’re not 'cleaning' your ship, Vander. They’re making sure nothing leaves it—",
		"#switch_to_chief",
		"o:Mr. Vander, unauthorized communications detected. We remind you that your employment contract prohibits external correspondence.",
	],
	[
		"#switch_to_mysterious",
		"o:Still alive?",
		"I guess so. Just rattled. Why do they destroy the ships?",
		"o:While they’re still alive, the 'Void Things' release microscopic spores. When those spores come into contact with inorganic material, they germinate, and the cells begin eating and multiplying. Metal, synthetic fibers, plastics—anything that isn’t alive is dinner.",
		"So... they’re eating the ships?",
		"o:Yeah, but that’s not the worst part. Once the cells multiply, they start building larger structures—flesh, bone, muscle. If you're lucky enough to survive your ship turning into meat, those larger structures will be happy to eat you...",
		"#switch_to_chief",
		"o:Mr. Vander, we have detected an anomaly in your ship’s systems. Remember, external communications are a violation of contract. We advise compliance.",
	],
	[
		"#switch_to_mysterious",
		"o:I see you’ve been snooping around again.",
		"Yeah. I'm trying to see if I can get in contact with one of the previous pilots.",
		"o:You won’t find any.",
		"Explain.",
		"o:The suits at CosmiCorp are cautious. If the 'contamination level' of a ship is too high, they deem it too risky to extract the pilot before destroying the ship. If I were you, I’d find another way to pay off your debt.",
		"I would if I could. If I refuse to take their jobs, they'll probably just throw me in debtors' prison—and rent me out to do the same work anyway.",
		"o:There is a way. It’s not foolproof, but it’s possible. I can help yo—",
		"…Hello?",
		"#switch_to_chief",
		"o:Hello, Mr. Vander. We have installed a new security update to protect you from unsolicited external communications. Have a pleasant day.",
	],
	[
		"#switch_to_chief",
		"o:Mr. Vander, your contamination levels are slightly higher than normal. Do not be alarmed. We will be performing a special decontamination procedure.",
		"Hmm… End of the line, huh. Even if I run, the ship is sealed from the outside. And communications are completely blocked. Headquarters is huge, but… I wonder how long it would take the contamination to spread there...",
		"o:Mr. Vander, your vessel is showing an unauthorized course correction. Do not return to headquarters. Proceed immediately to the designated decontamination site.",
		"…",
		"o:If you continue on this course, we will be forced to deploy armed security personnel!",
		"Thirty of them. One of me. I’ve gambled with worse odds before…",
	],
]
