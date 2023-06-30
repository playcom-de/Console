(******************************************************************************

  Name          : Ply.Defines.inc
  Copyright     : © 1999 - 2023 Playcom Software Vertriebs GmbH
  Last modified : 21.06.2023
  License       : disjunctive three-license (MPL|GPL|LGPL) see License.md
  Description   : This file is part of the Open Source "Playcom Console Library"

 ******************************************************************************)


  {$A+} // Record field alignment     : enabled
  {$X+} // Extended Syntax            : enabled
  {$H+} // Long strings               : enabled
  {$J-} // Assignable typed constants : disabled
  {$O+} // Optimization               : enabled
  {$P-} // Open parameters            : disabled
  {$W-} // stack frame generation     : disabled
  {$B-} // Complete boolean evaluation: disabled
  {$V+} // Strict var-strings         : enabled
  {$T-} // Typed @ operator           : disabled
  {$Z1} // Minimum enum size          : 1 = Byte

  {$IFDEF DEBUG}
    {$L+} // Local symbols        : enabled
    {$R+} // Range checking       : enabled
    {$S+} // Stack checking       : enabled
    {$Q+} // Overflow checking    : enabled
  {$ELSE}
    {$L-} // Local symbols        : disabled
    {$R-} // Range checking       : disabled
    {$S-} // Stack checking       : disabled
    {$Q-} // Overflow checking    : disabled
  {$ENDIF DEBUG}

  {$if CompilerVersion >= 30}     // >= Delphi 10 Seatle and up
    {$define DELPHI10UP}
    {$define CONSOLEOPACITY}
  {$else}
    {$define DELPHIXE8DOWN}       // <= Delphi XE8 and down
  {$ifend}



