#!/bin/bash

#735576, Briones Yus, Patricia, T, 1, A
#757024, Garcés Latre, Germán, T, 1, A

# -p con prioridad
uptime | logger -p local0.info
free | logger -p local0.info
df | logger -p local0.info
netstat | logger -p local0.info
ps | logger -p local0.info