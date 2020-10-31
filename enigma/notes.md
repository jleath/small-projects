<h1>Simulation of an Enigma Machine</h1>

<h2>Design of the Enigma Machine</h2>

<ul>
  <li>A combination of mechanical and electrical subsystems</li>
  <li>
    Mechanical Subsystems:
    <ul>
      <li>A <em>keyboard</em></li>
      <li>A set of rotating disks called <em>rotors</em></li>
      <li>A <em>spindle</em> along which the rotors are arranged</li>
      <li>A stepping component which <em>rotates</em> the rotors each time a key is pressed</li>
      <li>A series of <em>lights</em>, one for each letter</li>
    </ul>
  </li>
  <li>
  	Electrical Subsystem:
    <ul>
      <li>The mechanical parts form a varying electrical circuit.
      <li>Each time a rotor is rotated, a new electrical circuit is created.</li>
      <li>Each key is connected to a unique electrical circuit
      <li>This circuit changes upon each key press.</li>
    </ul>
  </li>
</ul>

<h3>The Rotors</h3>

<ul>
  <li>Each rotor itself performs a single substitution cipher.</li>
  <li>This subsitution is predetermined as the wiring within a rotor does not change. </li>
  <li>A rotor could be placed in any of 26 possible starting configurations.</li>
  <li>Upon each keypress, the right-most rotor <em>steps</em> by making 1/26th of a full rotation</li>
  <li>Other rotors would step less frequently, and this stepping varied slightly between models</li>
  <ul>
    <li>Notches and pawls could be configured to control this stepping process</li>
    <li>A ring with one or more notches was placed on a rotor, so that the notches aligned
        with specific letters</li>
    <li>A pawl on the rotor to the left of that one would catch on this notch when the rotor was at that character's position</li>
    <li>This would allow the left rotor to rotate with the right one.</li>
  </ul>
</ul>
<h3>The Reflector</h3>
<ul>
  <li>To the left of the rotors was a <em>reflector</em> which would send the signal back
      through the rotors, but taking a different path.</li>
  <li>A letter would always end up being permuted to a different letter position from
      where it started</li>
</ul>

<h3>The Plugboard</h3>

<ul>
  <li>A plugboard was connected between the keyboard and the right-most rotor</li>
  <li>This provided one additional permutation of the input before the signal went through the rotors</li>
  <li>This permutation was configured ahead of time and did not change like the rotors</li>
</ul>

<h3>Permutation Representation</h3>

<p>We will represent permutations using <em>cycle representation</em>
</p>

```
(AELTPHQXRU) (BKNW) (CMOY) (DFG) (IV) (JZ) (S)
```

<p>This notation indicates that A is mapped to E, E to L, L to T, ..., and U is mapped to A.
   The second cycle shows that B maps to K, K maps to N, N to W, W to B. The final cycle
   shows that S maps to itself. In our representation we will not include letters that map to
   themselves, so S would have just been excluded from our set</p>

<p>The inverse of these cycles is the inverse permutation. Just using the first cycle as an example, the inverse would be U maps to R, R to X, X to Q, ..., A to U.</p>

<p>The following table shows the rotors and reflectors we will use. Remember that these are preconfigured, we will only be manually setting the rotor configuration, the configuration of the plugboard, and possibly the position of the notches on the alphabet ring</p>

| Rotor       | Permutation (as cycles)                                      | Notch   |
| ----------- | ------------------------------------------------------------ | ------- |
| Rotor I     | (AELTPHQXRU) (BKNW) (CMOY) (DFG) (IV) (JZ) (S                | Q       |
| Rotor II    | (FIXVYOMW) (CDKLHUP) (ESZ) (BJ) (GR) (NT) (A) (Q)            | E       |
| Rotor III   | (ABDHPEJT) (CFLVMZOYQIRWUKXSG) (N)                           | V       |
| Rotor IV    | (AEPLIYWCOXMRFZBSTGJQNH) (DV) (KU)                           | J       |
| Rotor V     | (AVOLDRWFIUQ)(BZKSMNHYC) (EGTJPX)                            | Z       |
| Rotor VI    | (AJQDVLEOZWIYTS) (CGMNHFUX) (BPRK)                           | Z and M |
| Rotor VII   | (ANOUPFRIMBZTLWKSVEGCJYDHXQ)                                 | Z and M |
| Rotor VIII  | (AFLSETWUNDHOZVICQ) (BKJ) (GXY) (MPR)                        | Z and M |
| Rotor Beta  | (ALBEVFCYODJWUGNMQTZSKPR) (HIX)                              |         |
| Rotor Gamma | (AFNIRLBSQWVXGUZDKMTPCOYJHE)                                 |         |
| Reflector B | (AE) (BN) (CK) (DQ) (FU) (GY) (HW) (IJ) (LO) (MP) (RX) (SZ) (TV) |         |
| Reflector C | (AR) (BD) (CO) (EJ) (FN) (GT) (HK) (IV) (LM) (PW) (QZ) (SX) (UY) |         |