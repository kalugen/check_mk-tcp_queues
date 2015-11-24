<?php

# this file is free software;  you can redistribute it and/or modify it
# under the  terms of the  GNU General Public License  as published by
# the Free Software Foundation in version 2.  check_mk is  distributed
# in the hope that it will be useful, but WITHOUT ANY WARRANTY;  with-
# out even the implied warranty of  MERCHANTABILITY  or  FITNESS FOR A
# PARTICULAR PURPTCPE. See the  GNU General Public License for more de-
# ails.  You should have  received  a copy of the  GNU  General Public
# License along with GNU Make; see the file  COPYING.  If  not,  write
# to the Free Software Foundation, Inc., 51 Franklin St,  Fifth Floor,
# Boston, MA 02110-1301 USA.

setlocale(LC_ALL, "POSIX");

### Grafico 1: queues

# Opzioni generali di rrdtool
$opt[1] = "--vertical-label \"TCP Queues\"  --title \" $servicedesc\" -w800 -h200 -c CANVAS#555555 -c FONT#EEEEEE -c BACK#444444 --slope-mode";

# Dati da graficare
$def[1]  = rrd::def('recv_queue',     $RRDFILE[1], $DS[1], 'MAX');
$def[1] .= rrd::def('recv_queue_avg', $RRDFILE[1], $DS[2], 'MAX');
$def[1] .= rrd::def('send_queue',     $RRDFILE[1], $DS[3], 'MAX');
$def[1] .= rrd::def('send_queue_avg', $RRDFILE[1], $DS[4], 'MAX');

# Area con gradiente per i send - senza label
$def[1] .= rrd::gradient('send_queue','#0000CC','#99CCFF');

# Area con gradiente per i recv - senza label
$def[1] .= rrd::gradient('recv_queue','#00CC00','#99FFCC');

# Linea che si sovrappone al gradiente, con label
$def[1] .= rrd::line1('send_queue','#0000FF','Send Queues') ;
$def[1] .= rrd::line1('recv_queue','#00FF00','Recv Queues') ;

# Linee scure con il valore medio
#$def[1] .= rrd::line2('send_queue_avg','#0000AA','Send Queue Average') ;
#$def[1] .= rrd::line2('recv_queue_avg','#00AA00','Recv Queue Average') ;

# Riga orizzontale della soglia di warning per recv
if ($WARN[1] != "") {
   $def[1] .= "HRULE:$WARN[1]#FFFF00:\"Warning  at $WARN[1]$UNIT[1] \\n\" ";
}

# Riga orizzontale della soglia di critical per recv
if ($CRIT[1] != "") {
   $def[1] .= "HRULE:$CRIT[1]#FF0000:\"Critical at $CRIT[1]$UNIT[1]  \\n\" ";
}

### Grafrico 2: count

$opt[2] = "--vertical-label \"TCP Queues\"  --title \" $servicedesc\"  -c CANVAS#555555 -c FONT#EEEEEE -c BACK#444444 --slope-mode";

# Dati da graficare
$def[2]  = rrd::def('count',     $RRDFILE[1], $DS[5], 'MAX');
$def[2] .= rrd::def('count_avg', $RRDFILE[1], $DS[6], 'MAX');

# Area con gradiente per i count - senza label
$def[2] .= rrd::gradient('count','#999999','#CCCCCC');
# Linea che si sovrappone al gradiente, con label
$def[2] .= rrd::line1('count','#EEEEEE','Socket Count') ;

# Linea dell'average
$def[2] .= rrd::line3('count_avg','#FFFFFF','Socket Count Average') ;

# Riga orizzontale della soglia di warning per recv
if ($WARN[5] != "") {
   $def[2] .= "HRULE:$WARN[5]#FFFF00:\"Warning  at $WARN[5]$UNIT[5] \\n\" ";
}

# Riga orizzontale della soglia di critical per recv
if ($CRIT[5] != "") {
   $def[2] .= "HRULE:$CRIT[5]#FF0000:\"Critical at $CRIT[5]$UNIT[5]  \\n\" ";
}

?>
