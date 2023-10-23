extends Node

var skill_Speech = Skill.new("Speech","",6)
var skill_Sneak = Skill.new("Sneak","",6)
var skill_Guns = Skill.new("Guns","",6)
var skill_Handweapons = Skill.new("Hand weapons","")
var skill_Strength
var skill_Agility
var skill_Knowledge

var skillDictionary = {
	"Speech":"Speech is one's ability to verbally communicate with others.",
	"Sneak":"Sneak is one's ability to go around unnoticed.",
	"Guns":"Guns is one's ability to use every single types of guns or weapons shooting projectiles in general.",
	"HandWeapons":"Hand weapons is one's ability to use every single type of hand weapons such as blades, spears, etc.",
	"Strength":"Strength is one's ability to exert force on physical objects. ",
	"Agility":"Agility is one's ability to quickly change its body's positon.",
	"Knowledge":"Knowledge is one's ability to gather informations about the world."
}
