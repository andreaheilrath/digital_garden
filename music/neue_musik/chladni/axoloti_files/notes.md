###Some notes on how to convert stuff for Axoloti

1. Frequency to Pitch

The note E4 has a frequency of 329.63 Hz and corresponds to an integer value of 134217728. It is the 64th step in pitch (semitones), therefore one semitone corresponds to a difference of 2097152.

To determine the pitch value for a given frequency, one has to find out the distance in semitones. The 12th root of 2 is 1.059463094359. It seem sensible to determine the ratio of the given frequency to the frequency of E4 and take the logarithm of base 2 to get the number of octaves out.