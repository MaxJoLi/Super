GENERAL
Server.local.boot; //server boot
s = Server.local
s.boot; //server starts
s.quit; //server quits
Cmd + period (shorcut) //Kill engine

s.reboot; //reboot server

s.plotTree; //show active synths
s.meter; //in- and output-metering
s.freqscope; //spectrum
s.options.numInputBusChannels = 4; //set to 4 inputs
s.options.numOutputBusChannels = 2; //set to 2 outputs

x.stop; //stop x
x.free; //free synth, group etc.
s.freeAll; //end all synths, groups etc.

s.sendMsg(\n_free, int_NodeID) //free a node with Node-ID
_____________________________________________________________
_____________________________________________________________

OPERATORS, VARIABLES, CONVERSIONS ETC.

/* VARIABLES
a till z are reserved for gloabl/environment (used anywhere)
or
~nameVar; to declare global/environment
*/

4 + 2* 3; // no Mr. Van Dalen Wacht Op Antwoord
4 + (2 * 3);

-6.dbamp;
/*
convert dB's to envelope floats
0 dB is 1 "env" and -6 dB is ~0.5 "env"
*/

0.5.ampdb;
/*
convert amp/env floats to dB's
0.5 amp := ~-6 dB
0.25 amp := ~-12 dB
*/

6.mod(4.5); //modulu in Processing 6%4.5 = 1.5
11.round(20); //round to closest of enclosed number
21.roundUp(20); //round UP to closest of enclosed number
6!4; //make an array of # times the int/float
rrand(-8, 8); //random int between limits
rrand(-8.1, 8); //random float between limits
exprand(1, 100); //exp random

7.midiratio; //change semi-tones into 'speedratio'
63.midicps; //change MIDI-note into freq (cycles per second)

_____________________________________________________________
_____________________________________________________________

SYNTHS & SIGNALS

SinOsc.ar(freq, phase, mul, add)
SinOsc.ar(440, 0, 0, 0); //standard values

(
SynthDef.new(\nameofsynth, {
	SIGNAL
	}
).add;
)
x = Synth.new(\nameofsynth, [\arg1, valuearg1, \arg2, valuearg2]);
//make already evaluated synth with start-up arg
x.set(\arg, val);
//change args when synth is active

.ar = audiorate
.kr = control rate (1/64)
.ir = only when instatiated evaluated

freq[#, #] //make an array of freq

Mix.new(sig); //mix signals for mono Out
Splay.ar(sig, spread, level, center, levelComp); //mix for stereo Out

Rand(lo, hi); random float everytime synth is evaluated
ExpRand(lo, hi); random float exponantiollay distributed everytime synth is evaluated

/*
when envelope (e.g.) is evaluated, what action to do
doneAction:0 = do nothing (standard)
doneAction:2 = free the synth
*/

when x = synth
x.free; //free synth or what's stored in x

||||||||||||||||||
HEAR THE DIFFERENCE
x = {PinkNoise.ar(0.5!2)}.play; //"stereo" because array of freq
y = {PinkNoise.ar(0.5)!2}.play; //"mono" because array of pinknoise
x.free;
y.free;
||||||||||||||||||

LFNoise0.kr(8).exprange(#, #2) //output of noise is exponentially distributed

_____________________________________________________________
_____________________________________________________________

BUFFERS

~buf1 = Buffer.read(s, path, startFrame = 0, numFrames = 1, action, bufnum)
~buf1.play;
~buf1.zero; //clear but not remove buffer
~buf1.free; //free buffer completely (can not re-allocate)
~buf1.bufnum; //number of buffer, order of declaration
~buf1.query; //get path, bufnum, numFrames, numChannels and sampleRate

Buffer.readChannel(s, path, ... channels:[1]);
BufRateScale.kr(bufnum) //when dealing with different samplerate, proper conversions
numSamples = numFrames * numChannels

Buffer.freeAll; //free ALL buffers

||||||||||||||||||
numFrames = 1-indexed, when playing take 0-indexed into account!
||||||||||||||||||

_____________________________________________________________
_____________________________________________________________


ENVELOPE

Env.adsr(attackTime, decayTime, sustainLevel, releaseTime, peakLevel, curve, bias)
Env.adsr(0.01, 0.3, 0.5, 1, 1, -4, 0); //standard values
Env.new.plot; //plot envelope
Env.adsr(0.2, 0.6, 0.4, 1).plot;
Env.new(levels, times, curve, releaseNode, loopNode, offset)
Env.new([], [], \lin\exp\sin\sqr/floats/[arrayoffloats], t_gate (0,1 for retrigger), ?, only for IGenEnv);

Line.ar(start, end, dur, mul, add, doneAction);
Phasor.ar(trig, rate, start, end, resetPos);

_____________________________________________________________
_____________________________________________________________

MIDI

MIDIClient.init; //see all MIDI-devices
MIDIClient.sources;
MIDIIn.connectAll; //connect MIDI-input to all
MIDIIn.connect(#); //connect only to MIDI -client #

MIDIdef.noteOn(\nameofdef, {
	arg value (vel), number (note), chan (channel), src;
	function});
MIDIdef(\name).disable; //disable specified MIDI-def
MIDIdef(\name).enable; //enable specified MIDI-def
MIDIdef(\name).free; //free specified MIDI-def, need to reallocate
MIDIdef.freeAll; //free all



7.midiratio; //change semi-tones into 'speedratio'
63.midicps; //change MIDI-note into freq (cycles per second)

_____________________________________________________________
_____________________________________________________________

PATTERNS

(
Pbind(\instrument, \nameofsynth
	\freq, Pseq([...], # of repeats).trace,
	//freq is # times sequenced according to entries in array. Trace = postln
	\dur, Pseq([...], inf)//repeat infinite

	//when standard args are used (freq, amp etc. is used specific controls can be used (midinote, db etc.)
	//Pkey can be used to backward acces values in Pbind

).play;
)

Pexprand(lo, hi, length); //new value (exponantially) everytime evaluated
Pwhite(lo, hi, inf); //new value linearly, infinite
Prand

_____________________________________________________________
_____________________________________________________________

BUSSES, GROUPS AND ROUTING

~bus1 = Bus.audio(s, #channels); create new bus
~bus1.set(\arg, value); //set arg for all in group

g = Group.new(s, \addToTail); //add group add tail in server
h = Group.new(x, \addAfter); //add group after x

_____________________________________________________________
_____________________________________________________________

FOLDERS, PATHS, DICT, ARRAYS

a = Array.new(maxSize); //entries are nil
a = [1, 2, 3, 4]; //make an array with entries

(
~harp = Array.new;
~folder = PathName.new(path); //path = "/path/" of the folder with samples
(~folder.entries.do(
	{ arg path;
	 ~harp = ~harp.add(Buffer.read(s, path.fullPath));
	});
) // load all samples in a folder into a ~harp[i] buffer
)
~harp[#].play; //play # entry of buffer-folder

(
d = Dictionary.new;
d.add(\name -> PathName(path).entries.collect({
	arg argument;
	Buffer.read(s, argument.fullPath);
	});
);
)//

b = [5, 6, 7, 8]; //make an array with entries

c = a++b; //make new SINGLE array with values of a then b
c = [a]++[b]; //concatenate arrays into DOUBLE array c
c; //returns two arrays
c.size; //size of c = 2 (entries/arrays)
c.[0].size; //size of array entry 0

a.size; //size of array
[1, 2, 3, 4].choose; //choose from array