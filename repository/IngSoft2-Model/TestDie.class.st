Class {
	#name : 'TestDie',
	#superclass : 'Object',
	#instVars : [
		'forcedRoll'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
TestDie class >> withForcedRoll: aNumber [
	^self new initializeWithForcedRoll: aNumber.
]

{ #category : 'initialization' }
TestDie >> initializeWithForcedRoll: aNumber [
	forcedRoll := aNumber.
	
]

{ #category : 'accessing' }
TestDie >> rollDice [ 
^forcedRoll 
]
