Class {
	#name : #Ship,
	#superclass : #Object,
	#instVars : [
		'name',
		'fuel'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'as yet unclassified' }
Ship class >> withName: aName and: aFuelAmount [

	^ self new initializeWith: aName and: aFuelAmount
]

{ #category : #accessing }
Ship >> consumeFuel: steps [ 
	fuel := fuel - steps.

]

{ #category : #accessing }
Ship >> fuel [

	^ fuel
]

{ #category : #'as yet unclassified' }
Ship >> initializeWith: aName and: aFuelAmount [

	name := aName.
	fuel := aFuelAmount
]

{ #category : #accessing }
Ship >> moveS: steps in: board [ 
	self consumeFuel: steps.
	board moveShip: self steps: steps.


]

{ #category : #accessing }
Ship >> name [

	^ name
]
