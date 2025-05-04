Class {
	#name : 'DiceTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
DiceTest >> should: anErrorBlock raise: anErrorClass withMessageText: errorMessage [

    self
        should: anErrorBlock
        raise: anErrorClass
        withExceptionDo: [ :error |
            self assert: (error messageText) equals:
                errorMessage ]
]

{ #category : 'tests' }
DiceTest >> testIfDiceResultIsIntegerThenIsValid [
	| aDice |
	aDice := Dice with: 6.
	self assert: aDice result isInteger. 
]

{ #category : 'tests' }
DiceTest >> testIfNumberOfSidesEqualsTheNumberOfSidesTheDieIsInitializedWithThenIsValid [

	| aNumberOfSides aDice |
	aNumberOfSides := 5.
	aDice := Dice with: aNumberOfSides.
	
	self assert: aDice sides = aNumberOfSides
]

{ #category : 'tests' }
DiceTest >> testIfNumberOfSidesInvalidThenInvalid [

	self
		should: [ Dice numberOfSidesIsHigherThanOne: 1 ]
		raise: Error
		withMessageText:
		'The die number of sides should at least be higher than 1.'
]
