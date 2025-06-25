Class {
	#name : 'FuelDebuffReward',
	#superclass : 'Reward',
	#instVars : [
		'debuff'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'instance creation' }
FuelDebuffReward class >> by: anAmount [ 
	
	^ self new initializeWith: anAmount
]

{ #category : 'initialization' }
FuelDebuffReward >> applyTo: aSpaceship [

	aSpaceship consumeFuel: debuff
]

{ #category : 'initialization' }
FuelDebuffReward >> initializeWith: anAmount [

	debuff := anAmount
]
