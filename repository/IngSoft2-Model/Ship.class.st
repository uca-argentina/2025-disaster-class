Class {
	#name : 'Ship',
	#superclass : 'Object',
	#instVars : [
		'name'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
Ship class >> withName: aName [

	^ self new initializeWith: aName
]

{ #category : 'as yet unclassified' }
Ship >> initializeWith: aName [

	name := aName
]

{ #category : 'accessing' }
Ship >> name [

	^ name
]
