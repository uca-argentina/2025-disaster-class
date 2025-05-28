Class {
	#name : #HyperJumpCell,
	#superclass : #Cell,
	#instVars : [
		'parsecList',
		'index',
		'totalParsecs'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'as yet unclassified' }
HyperJumpCell class >> withParsecList: aList totalParsecs: aTotal [
    ^ self new initializeWithParsecList: aList totalParsecs: aTotal
]

{ #category : #'as yet unclassified' }
HyperJumpCell >> applyEffectTo: aShip in: aBoard [
    | parsecs parsecsPerCell cellsToAdvance |

    parsecs := parsecList at: index.
    index := index + 1.
    index > parsecList size ifTrue: [ index := 1 ]. 

    parsecsPerCell := totalParsecs // aBoard size.
    cellsToAdvance := parsecs // parsecsPerCell.

    aShip moveS: cellsToAdvance in: aBoard.
]

{ #category : #initialization }
HyperJumpCell >> initializeWithParsecList: aList totalParsecs: aTotal [

	super initialize.
	parsecList := aList.
	totalParsecs := aTotal.
	index := 1
]
