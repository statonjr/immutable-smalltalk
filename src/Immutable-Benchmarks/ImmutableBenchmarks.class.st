"
I am the abstract SMark base for the Immutable collections benchmark suites.

Run the complete benchmark set with:

    ImmutableBenchmarks runAll

Run one family with:

    ImmutableMapBenchmarks runAndReport

Benchmarks use:
	- SMarkCogRunner warmup behavior
   - a microsecond-resolution timer expressed as fractional milliseconds
   - nine recorded post-warmup samples
   - median, range, relative spread, and operations per second
   - correctness validation outside timed regions
"
Class {
	#name : 'ImmutableBenchmarks',
	#superclass : 'SMarkSuite',
	#category : 'Immutable-Benchmarks',
	#package : 'Immutable-Benchmarks'
}

{ #category : 'benchmarking' }
ImmutableBenchmarks class >> benchmarkSuites [

      ^ {
           ImmutableMapBenchmarks.
           ImmutableVectorBenchmarks.
           ImmutableConstructionBenchmarks.
           ImmutableStructuralSharingBenchmarks.
           ImmutableViewBenchmarks.
           ImmutableSequenceBenchmarks.
           ImmutableSetBenchmarks.
           ImmutableQueueBenchmarks.
           ImmutableSortedBenchmarks
        }
]

{ #category : 'defaults' }
ImmutableBenchmarks class >> defaultRunner [

      ^ ImmutableBenchmarkRunner
]

{ #category : 'defaults' }
ImmutableBenchmarks class >> defaultSampleCount [

	^ 9
]

{ #category : 'private' }
ImmutableBenchmarks class >> environmentValueFrom: object
      selector: selector
      ifAbsent: fallback [

      ^ (object respondsTo: selector)
           ifTrue: [ object perform: selector ]
           ifFalse: [ fallback ]
]

{ #category : 'benchmarking' }
ImmutableBenchmarks class >> isAbstractClass [ 

	^ true
]

{ #category : 'statistics' }
ImmutableBenchmarks class >> medianOf: numbers [

      | sorted middle |
      sorted := numbers sorted.
      middle := (sorted size + 1) // 2.

      sorted size odd ifTrue: [
         ^ sorted at: middle ].

      ^ ((sorted at: middle) + (sorted at: middle + 1)) / 2.0
]

{ #category : 'reporting' }
ImmutableBenchmarks class >> reportEnvironment [

	| image operatingSystem architecture wordSize |
	image := SmalltalkImage current.

	operatingSystem := OSPlatform current.

	architecture := operatingSystem processorArchitecture.

	wordSize := image wordSize.

	Transcript
		show: '=== Immutable Collections Benchmark Environment ===';
		cr;
		show: 'Timestamp: ';
		show: DateAndTime now printString;
		cr;
		show: 'Pharo: ';
		show: SystemVersion current asString;
		cr;
		show: 'VM: ';
		show: (self environmentValueFrom: Smalltalk vm selector: #version ifAbsent: 'unknown') asString;
		cr;
		show: 'OS: ';
		show: (self environmentValueFrom: operatingSystem selector: #platformName ifAbsent: operatingSystem class name) asString;
		cr;
		show: 'Architecture: ';
		show: architecture asString;
		cr;
		show: 'Word size: ';
		show: wordSize asString;
		cr;
		show: 'Runner: ';
		show: ImmutableBenchmarkRunner name;
		cr;
		show: 'Timer: ';
		show: ImmutableBenchmarkTimer name;
		cr;
		show: 'Warmup executions: 2';
		cr;
		show: 'Recorded samples: ';
		show: self defaultSampleCount printString;
		cr;
		cr
]

{ #category : 'reporting' }
ImmutableBenchmarks class >> reportResults: runner [

	| metadata |
	metadata := self benchmarkMetadata.

	metadata keys sorted do: [ :benchmark |
			| results times median minimum maximum specification operationCount unit operationsPerSecond spreadPercent |
			results := runner results at: benchmark.
			times := results collect: [ :result | result total ].

			median := self medianOf: times.
			minimum := times min.
			maximum := times max.

			specification := metadata at: benchmark.
			operationCount := specification first.
			unit := specification second.

			median <= 0
				ifTrue: [
						Transcript
							show: benchmark asString;
							show: ': below timer resolution, samples ';
							show: times printString;
							cr ]
				ifFalse: [
						operationsPerSecond := operationCount * 1000.0 / median.

						spreadPercent := maximum - minimum / median * 100.0.

						Transcript
							show: benchmark asString;
							show: ': median ';
							show: (median printShowingDecimalPlaces: 3);
							show: ' ms, range ';
							show: (minimum printShowingDecimalPlaces: 3);
							show: '-';
							show: (maximum printShowingDecimalPlaces: 3);
							show: ' ms, spread ';
							show: (spreadPercent printShowingDecimalPlaces: 2);
							show: '%, ';
							show: operationCount printString;
							space;
							show: unit;
							show: ', ';
							show: operationsPerSecond rounded printString;
							space;
							show: unit;
							show: '/s';
							cr ] ]
]

{ #category : 'running' }
ImmutableBenchmarks class >> runAll [

      | runners |
      self reportEnvironment.
      runners := Dictionary new.

      self benchmarkSuites do: [ :suite |
         runners
            at: suite name
            put: suite runAndReportSuite ].

      ^ runners
]

{ #category : 'running' }
ImmutableBenchmarks class >> runAndReport [

      self reportEnvironment.
      ^ self runAndReportSuite
]

{ #category : 'reporting' }
ImmutableBenchmarks class >> runAndReportSuite [

      | runner |
      Transcript
         show: '=== ';
         show: self name;
         show: ' ===';
         cr.

      runner := self run: self defaultSampleCount.
      self reportResults: runner.
      Transcript cr.

      ^ runner
]
