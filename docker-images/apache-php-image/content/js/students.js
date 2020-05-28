$(() => {
	console.log("Loading students");

	function loadStudents() {

		$.getJSON("/api/students/", (students) => {
	
			console.log(students);

			let message = "Nobody is here";

			if(students.length > 0) {
				message = students[0].name;
			}
		
			$('.skills').text(message);
		});
	}

	loadStudents();	
	setInterval(loadStudents, 2000);
});

