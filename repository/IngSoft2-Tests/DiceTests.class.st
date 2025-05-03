Class {
	#name : 'DiceTests',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
DiceTests >> should: anErrorBlock raise: anErrorClass withMessageText: errorMessage [

    self
        should: anErrorBlock
        raise: anErrorClass
        withExceptionDo: [ :error |
            self assert: (error messageText) equals:
                errorMessage ]
]

{ #category : 'tests' }
DiceTests >> testA [

]

{ #category : 'tests' }
DiceTests >> testIfNumberOfSidesEqualsTheNumberOfSidesTheDieIsInitializedWithThenIsValid [

	| aNumberOfSides aDice |
	aNumberOfSides := 5.
	aDice := Dice with: aNumberOfSides.
	
	self assert: aDice sides = aNumberOfSides
]

{ #category : 'tests' }
DiceTests >> testIfNumberOfSidesInvalidThenInvalid [

	self
		should: [ Dice numberOfSidesIsHigherThanOne: 1 ]
		raise: Error
		withMessageText:
		'The die number of sides should at least be higher than 1.'
]
