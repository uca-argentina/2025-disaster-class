Class {
	#name : #DiceTest,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
DiceTest >> should: anErrorBlock raise: anErrorClass withMessageText: errorMessage [

    self
        should: anErrorBlock
        raise: anErrorClass
        withExceptionDo: [ :error |
            self assert: (error messageText) equals:
                errorMessage ]
]

{ #category : #tests }
DiceTest >> testIfDiceResultIsIntegerThenIsValid [
	| aDice |
	aDice := Die with: 6.
	self assert: aDice rollDice isInteger. 
]

{ #category : #tests }
DiceTest >> testIfNumberOfSidesEqualsTheNumberOfSidesTheDieIsInitializedWithThenIsValid [

	| aNumberOfSides aDice |
	aNumberOfSides := 5.
	aDice := Die with: aNumberOfSides.
	
	self assert: aDice sides = aNumberOfSides
]

{ #category : #tests }
DiceTest >> testIfNumberOfSidesInvalidThenInvalid [

	self
		should: [ Die numberOfSidesIsHigherThanOne: 1 ]
		raise: Error
		withMessageText:
		'The die number of sides should at least be higher than 1.'
]

{ #category : #tests }
DiceTest >> testIfRollIsBetweenTwoNumbersThenIsValid [

	| aDice roll |
	aDice := Die with: 20.
	roll := aDice rollDice.
	self assert: (roll >= 1 and: [ roll <= 20 ])
]

{ #category : #tests }
DiceTest >> testThatIfRollIsBetween1AndNumberOfSidesThenIsValid [

	| aDice roll numberOfSides|
	numberOfSides := 6.
	aDice := Die with: numberOfSides .
	roll := aDice rollDice.
	self assert: (roll >= 1 and: [ roll <= numberOfSides ])
]

{ #category : #tests }
DiceTest >> testYouCanForceRollSequenceOfDieResults [
	| die rolls |
	
	rolls := #(3 5 2).
	die := TestDie withRolls: rolls.

	self assert: die rollDice equals: 3.
	self assert: die rollDice equals: 5.
	self assert: die rollDice equals: 2.

]
