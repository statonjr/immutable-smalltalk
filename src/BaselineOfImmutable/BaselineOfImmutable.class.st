Class {
	#name : 'BaselineOfImmutable',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfImmutable',
	#package : 'BaselineOfImmutable'
}

{ #category : 'baselines' }
BaselineOfImmutable >> baseline: spec [
    <baseline>

      spec for: #pharo do: [
         spec
            baseline: 'SMark'
            with: [
               spec repository: 'github://guillep/SMark:master' ].

         spec
            package: 'Immutable-Collections';
            package: 'Immutable-HAMT';
            package: 'Immutable-Platform';

            package: 'Immutable-Pharo'
            with: [
               spec requires: #(
                  'Immutable-Platform'
               ) ];

            package: 'Immutable-Core'
            with: [
               spec requires: #(
                  'Immutable-Collections'
                  'Immutable-HAMT'
                  'Immutable-Platform'
               ) ];

            package: 'Immutable-HAMT-Tests'
            with: [
               spec requires: #(
                  'Immutable-HAMT'
                  'Immutable-Pharo'
               ) ];

            package: 'Immutable-Core-Tests'
            with: [
               spec requires: #(
                  'Immutable-Core'
                  'Immutable-Pharo'
               ) ];

            package: 'Immutable-Benchmarks'
            with: [
               spec requires: #(
                  'Immutable-Core'
                  'Immutable-Pharo'
                  'SMark'
               ) ].

         spec
            group: 'Core'
            with: #(
               'Immutable-Pharo'
               'Immutable-Core'
            );

            group: 'Tests'
            with: #(
               'Core'
               'Immutable-HAMT-Tests'
               'Immutable-Core-Tests'
            );

            group: 'Benchmarks'
            with: #(
               'Core'
               'Immutable-Benchmarks'
            );

            group: 'Development'
            with: #(
               'Tests'
               'Benchmarks'
            );

            group: 'default'
            with: #(
               'Core'
            )
      ]
]
