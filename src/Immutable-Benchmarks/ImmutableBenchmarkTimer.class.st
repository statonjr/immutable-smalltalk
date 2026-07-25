Class {
	#name : 'ImmutableBenchmarkTimer',
	#superclass : 'SMarkTimer',
	#category : 'Immutable-Benchmarks',
	#package : 'Immutable-Benchmarks'
}

{ #category : 'timing' }
ImmutableBenchmarkTimer >> currentMillis [

      "Express the microsecond clock as fractional milliseconds so that
      SMarkResult continues to use milliseconds."

      ^ Time microsecondClockValue / 1000.0
]
