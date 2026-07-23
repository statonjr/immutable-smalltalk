Class {
	#name : 'BaselineOfImmutable',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfImmutable',
	#package : 'BaselineOfImmutable'
}

{ #category : 'baselines' }
BaselineOfImmutable >> baseline: spec [
    <baseline>
    spec for: #common do: [
        spec
            package: 'Immutable-Core';
            package: 'Immutable-Platform';
            package: 'Immutable-Tests' with: [spec requires: #('Immutable-Core')].
        
        "Platform-specific packages loaded conditionally"
        spec for: #pharo do: [
            spec package: 'Immutable-Pharo' with: [spec requires: #('Immutable-Core' 'Immutable-Platform')]]].
]
