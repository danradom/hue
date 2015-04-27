I wrote this because it is useful to me.  It probably isn't to you, but is it a good example of how to interact with philips hue and lux lighting from the unix command line.


Shell scripts I wrote to contol my Philips Hue, LightStrips. and Lux lighting

The script can be used to control lights by either group name or light number


#   name               type           state      reachable  bri        hue
------------------------------------------------------------------------------
1    living room 1     hue            OFF        YES
2    living room 2     hue            OFF        YES
3    living room 3     hue            OFF        YES
4    living room 4     hue            OFF        YES
5    kitchen 1         hue            OFF        YES
6    kitchen 2         hue            OFF        YES
7    kitchen 4         hue            OFF        YES
8    kitchen 3         hue            OFF        YES
9    sink              hue            OFF        YES
10   hall              hue            OFF        YES
11   bedroom           hue            OFF        YES
12   sam               hue            OFF        YES
13   bailey            hue            OFF        YES
14   outside front     lux            OFF        YES
15   outside garage    lux            OFF        YES
16   outside back      lux            OFF        YES
17   bus               lux            OFF        YES
18   honda             lux            OFF        YES
19   lightstrip 1      lightstrip     OFF        YES
20   lightstrip 2      lightstrip     OFF        YES
21   lamp              lux            OFF        YES


hue kitchen on 120
hue kitchen status
#   name               type           state      reachable  bri        hue
------------------------------------------------------------------------------
5    kitchen 1         hue            ON         YES        120        14920
6    kitchen 2         hue            ON         YES        120        14920
7    kitchen 4         hue            ON         YES        120        14920
8    kitchen 3         hue            ON         YES        120        14920


hue 7 off
hue kitchen status
#   name               type           state      reachable  bri        hue
------------------------------------------------------------------------------
5    kitchen 1         hue            ON         YES        120        14948
6    kitchen 2         hue            ON         YES        120        14948
7    kitchen 4         hue            OFF        YES
8    kitchen 3         hue            ON         YES        120        14948
