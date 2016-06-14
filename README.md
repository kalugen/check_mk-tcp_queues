# Check TCP Queues

*Versione 1.0.2* 

Il check verifica il numero di pacchetti in coda sui socket TCP, riportando i dati relativi a:
 * code di send
 * code di receive
 * numero di socket

## Configurazione
Ci sono due punti di configurazione, inventory e parametri

### Inventory
Senza regole di inventory, il check non crea nessun servizio nagios. Le regole di inventory devono essere descritti con 3 parametri:
 * location (local o remote), in modo che il check consideri i socket usando come chiave o l'indirizzo remoto o quello locale
 * IP address del socket, che può essere settato in tre modi:
  * La stringa "ANY": matcha qualsiasi indirizzo
  * Un indirizzo di host IP: matcha un singolo indirizzo IPv4 o IPv6
  * Un indirizzo di rete IPv4 con un CIDR: matcha tutti gli indirizzi nella rete
 * Porta del socket, che può essere settata in due modi:
  * La stringa "ANY": matcha qualsiasi porta
  * Un numero tra 1 e 65535: matcha la specifica porta

Ho usato "ANY" e non un più intuitivo "*" perché il carattere "*" è vietato da Nagios e per evitare problemi di compatibilità ho preferito ripiegare su "ANY".

Non supporto IPv6 sul matching della rete - per il momento - a causa della diversa notazione utilizzata al posto del classico "dotted decimal" di IPv4, per la quale non ho ancora scritto un parser che converta la stringa in un numero (necessario per poter fare i calcoli sulle netmask).

### Parameters
Ci sono 4 possibili parameters settabili via regola:
 * socket_count: numero massimo di socket/connessioni aperte
 * recv_queue_levels: numero massimo di pacchetti in coda di receive
 * send_queue_levels: numero massimo di pacchetti in coda di send
 * average_minutes: minuti su cui calcolare la media mobile

I defaults:
```python
factory_settings["tcp_queues_defaults"] = {
  "socket_count_levels" : (100000,200000),
  "recv_queue_levels"   : (100000,200000),
  "send_queue_levels"   : (100000,200000),
  "average_minutes"     :  15
}
```

## Perfdata

Ogni service fornisce 6 perfdata: i valori send, recv e count + le rispettive medie mobili calcolate su "average_minutes"

