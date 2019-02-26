(
		SynthDef(\Banco,
				{| freq1, freq2,freq3, transitionTime1,densidad
					sustainTime,transitionTime2,ataque, sustain, release, amplitud, amp=0.1 |

					var signal, senal, env, env1;

				env1= EnvGen.ar(Env([0,1,0.5,0],[ataque,sustain,release], \linear),
			Impulse.ar(10, Array.series(10,0,0.3 )));

				 senal = { DynKlank.ar(
					`[Array.series(10,freq1,freq2),
						Array.series(10,0.5,0.05),
						Array.series(10,4,-0.1)],
					BrownNoise.ar(0.001)) };

					signal= (senal*env1)!2;

					env = EnvGen.ar(
						Env([ 0,0.5,0.5,0],
							[ transitionTime1, sustainTime,
								transitionTime2],

							\sine
						),
						1,
						doneAction:2
					);
					Out.ar(0, signal * env )
			}).add;

SynthDef(\Banco2,
				{| freq1, freq2,freq3, transitionTime1,densidad
					sustainTime,transitionTime2,ataque, sustain, release, amplitud2,amp = 0.5 |

					var signal, senal, env, env1;

				env1= EnvGen.ar(Env([0,1,0.5,0],[ataque,sustain,release], \linear),
			Impulse.ar(freq3));

				 senal = { DynKlank.ar(
					`[Array.series(10,freq1,freq2),
						Array.series(10,0.5,0.05),
						Array.series(10,4,-0.1)],
					BrownNoise.ar(amplitud2))};

					signal= (senal*env1)!2;

					env = EnvGen.ar(
						Env([ 0, 0.5,0.5, 0],
							[ transitionTime1, sustainTime,
								transitionTime2],
							\sine
						),
						1,
						doneAction:2
					);
					Out.ar(0, signal * env)
			}).add


		)



(


n = NetAddr.new("127.0.0.1", 7400);
thisProcess.openUDPPort(7400);

f = { |msg|
    if(msg[0] == '/giveme') {
		//msg.postln;
	   a=msg;
		c=a.asInteger;
		//b=c[1].asBinaryDigits;
		c.postln;

    }
};
thisProcess.addOSCRecvFunc(f);




			Routine({
				var transitionTime1, sustainTime, transitionTime2, tiempos;
				transitionTime1 = 1;

				inf.do({

		//c[7].postln;
				sustainTime = 1;
				transitionTime2 = 1;

			Synth(\Banco, [
			        \freq1, (c[1])*2,
					\freq2, (c[2])/2,
					\freq3, 10,
			\ataque,0.1,
			\sustain,0.1,
			\release,0.1,
					\transitionTime1, transitionTime1,
					\sustainTime, sustainTime,
					\transitionTime2, transitionTime2;
			\amplitud,0.001,
					]);

		Synth(\Banco2, [
			       \freq1, (c[3])*2,
			\freq2, c[4],
			\freq3, c[5],
			\ataque,(c[6])/10000,
			\sustain,(c[7])/1000,
			\release,(c[8])/1000,
					\transitionTime1, transitionTime1,
					\sustainTime, sustainTime,
					\transitionTime2, transitionTime2,
			\amplitud2,(c[9])/10000,
					]);


					tiempos = [ transitionTime1, sustainTime, transitionTime2].round(0.1);
					//[tiempos.sum, tiempos].postln;
					(transitionTime1+ sustainTime).wait;
					transitionTime1 = transitionTime2;


				})
			}).play
		)

s.freqscope


thisProcess.removeOSCRecvFunc(f);// evaluar para parar de recibir osc