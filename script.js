$(document).ready(function () {
  // Function to handle the button click event
  $("#registerBtn").click(function () {
    var username = $("#username").val(); // Get the value from the input field
    var requestData = {
      symbol: username,
      faction: "COSMIC",
    };

    $.ajax({
      url: "https://api.spacetraders.io/v2/register",
      type: "POST",
      contentType: "application/json",
      data: JSON.stringify(requestData),
      success: function (response) {
        console.log(response);
        var accessToken = response.data.token;
        $("#response").text(accessToken);
        alert("Registration successful!");
      },
      error: function (xhr, status, error) {
        console.error(error);
        alert("Registration failed. Please try again.");
      },
    });
  });
});
