async function fireconn()
{

    var firebaseConfig = {
        apiKey: "",
        authDomain: "",
        databaseURL: "",
        projectId: "",
        storageBucket: "",
        messagingSenderId: "",
        appId: "",
        measurementId: ""
      };
      // Initialize Firebase
     await firebase.initializeApp(firebaseConfig);
      console.log("connection established");
}

function myFunction()
{
  document.querySelector('.loader').style.visibility= "visible";
  window.location.href = "log.html";
}

function signup()
{
  document.querySelector('.loader').style.visibility= "visible";
  //fireconn();
  
    var email= document.getElementById("ename").value;
    var password= document.getElementById("pass").value;
    var username= document.getElementById("uname").value;
    
    firebase.auth().createUserWithEmailAndPassword(email, password).then((user)=>{
      firebase.database().ref('users/'+username).set({username:username,email:email});
      var users = firebase.auth().currentUser;
      users.updateProfile({
        displayName: username,
      }).then(function() {
        console.log(users);
    console.log(users.displayName);
        console.log(users.displayName);
        var user = firebase.auth().currentUser;

        document.querySelector('.loader').style.visibility= "hidden";  
        alert('Account created Successfully, Please Login to continue');
        
      // user.sendEmailVerification().then(function() {
      //   // Email sent.
      // }).catch(function(error) {
      //   // An error happened.
      // });
      }).catch(function(error) {
        console.log(error.message);
      });
      
      // setTimeout(myFunction, 10000)
      // window.location.href = "log.html";

    }).catch(function(error) {
        console.log(error.code);
        console.log(error.message);
        alert(error.message);
        document.querySelector('.loader').style.visibility= "hidden";
     });
}

function login()
{
  document.querySelector('.loader').style.visibility= "visible";
    //fireconn();
      var email= document.getElementById("ename").value;
      var password= document.getElementById("pass").value;
      
      firebase.auth().signInWithEmailAndPassword(email, password).then((user)=>{
        window.location.href = "home.html";
      }).catch(function(error) {
          console.log(error.code);
          console.log(error.message);
          alert(error.message);
          document.querySelector('.loader').style.visibility= "hidden";
       });
    

}

function logout()
{
  //fireconn();
  firebase.auth().signOut().then(() => {
    window.location.href = "index.html";
  }).catch((error) => {
    console.log(error.code);
          console.log(error.message);
          alert(error.message);
  });
}

async function checklogstatus()
{
  fireconn();
  document.querySelector('.loader1').style.visibility= "visible";
  await firebase.auth().onAuthStateChanged(function(user) {
    if (user) {
      console.log("user logged in");
  document.querySelector('.loader1').style.visibility= "hidden";
    } else {
      console.log("user not preset");
      window.location.href = "log.html";
    }
  });
}