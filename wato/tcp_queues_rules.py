# Inventory rule definition for WATO
# -*- encoding: utf-8; py-indent-offset: 2 -*-

register_rule("checkparams" + "/" +  _("Inventory - automatic service detection"),
    # This is the name of the variable that this rule will populate
    # THE VARIABLE MUST BE DECLARED ALSO IN THE CHECK, wher it will be used
    # in the inventory function
    varname     = "desired_tcp_queues",
    # Label for the variable
    title         = _("TCP queues discovery "),
    # Structure of the data the variable will hold
    valuespec = ListOf(
        Dictionary(
            title = _("Socket"),
            help  = _("This defines one socket rule"),
            elements = [
                ('desired_socket',
                    Dictionary(
                        show_titles = False,
                        elements = [
                            ('location',
                                DropdownChoice(
                                    title     = _("Location"),
                                    default_value = 'L',
                                    choices =    [
                                        ('L', _('LOCAL')),
                                        ('R', _('REMOTE')),
                                    ],
                                    allow_empty = False,
                                ),
                            ),
                            ('address',
                                TextAscii(
                                    title = _("Address"),
                                    help    = _("IPv4 or IPv6 address of the socket, special string \"ANY\" means \"any address\". "
                                                "It is possible to specify either a single address or network address "
                                                "in CIDR format"
                                    ),
                                    default_value = "ANY",
                                    allow_empty = False,
                                ),
                            ),
                            ('port',
                                TextAscii(
                                    title = _("Port"),
                                    help    = _("port, special string \"ANY\" means \"match any port\""),
                                    default_value = "ANY",
                                    allow_empty = False,
                                ),
                            ),
                        ],
                    ),
                ),
            ],
        ),
        movable = False,
        title = _("List of sockets to check")
    ),
    match= 'all',
)

# Check parameter rule definition for WATO
register_check_parameters(
    _("Operating System Resources"), # It will appear in WATO
    "tcp_queues_group", # "group" : this must match the "group" key used in check_info
    _("TCP queues Usage Levels"), # Title of the rule, it will appear in WATO
    # All check parameters are dictionaries, always use a dictionary
    Dictionary(
        elements = [
            # A tuple (think read-only array), with two elements with a maxval
            # (enforced client-side by WATO)
            ("recv_queue_levels",
                Tuple(
                    title = _("Levels for receive queues usage"),
                    label = _("Levels for receive queues usage"),
                    elements = [
                        Integer(title = _("Warning at:" ), maxvalue = 15000000),
                        Integer(title = _("Critical at:"), maxvalue = 15000000),
                    ]
                ),
            ),
            ("send_queue_levels",
                Tuple(
                    title = _("Levels for send queues usage"),
                    label = _("Levels for send queues usage"),
                    elements = [
                        Integer(title = _("Warning at:" ), maxvalue = 15000000),
                        Integer(title = _("Critical at:"), maxvalue = 15000000),
                    ]
                ),
            ),
            ("socket_count_levels",
                Tuple(
                    title = _("Count for specific socket"),
                    label = _("Count for specific socket"),
                    elements = [
                        Integer(title = _("Warning at:" ), maxvalue = 15000000),
                        Integer(title = _("Critical at:"), maxvalue = 15000000),
                    ]
                ),
            ),
            # A single integer
            ("average_minutes",
                Integer(
                    title = _("Average Minutes"),
                    label = _("Average Minutes"),
                    unit  = _("minutes"),
                    help  = _("Minutes over which to calculate the average"),
                    maxvalue = 60*24 # 24h, in minutes
                )
            ),

        ],
    ),
    # This can be used to match only a particular set of items (regex)
    TextAscii(
        title = _("queues"),
        help  = _(""),
        allow_empty = True,
    ),
    # Format of the parameter variable that this rule will create
    "dict"
)
