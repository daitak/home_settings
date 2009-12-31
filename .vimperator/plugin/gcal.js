
commands.addUserCommand(
        ['gc[al]'],
        'google calendar',
        function () { liberator.open('http://www.google.com/calendar/render');},
        { shortHelp: 'open google calendar' },
        false
);



/*
commands.addUserCommand(
		["hello[world]","hw"],
		"print hello world",
		function(){
		liberator.echo("Hello World");
		}
		);
		*/
