package fr.iutlan.tp4.jetpack_compose_practice

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import fr.iutlan.tp4.jetpack_compose_practice.feu3.ui.MainActivityFeu3View
import fr.iutlan.tp4.jetpack_compose_practice.ui.theme.JetpackcomposepracticeTheme

class MainActivity : ComponentActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
                JetpackcomposepracticeTheme {
                // A surface container using the

                            Surface(
                                modifier = Modifier.fillMaxSize(),
                                color = MaterialTheme.colorScheme.background
                            ) {
                                MainActivityFeu3View()
                            }
            }
            // AccueilMultiplePreview()
        }
//        setContent {
//            Text(
//                text = "Bonjour tout le monde !",
//                fontWeight = FontWeight.Bold,
//                fontSize = 32.sp,
//                color = Color.Magenta
//            )
//        }
//        enableEdgeToEdge()
//        setContent{
//            JetpackcomposepracticeTheme {
//                Scaffold(modifier = Modifier.fillMaxSize()) { innerPadding ->
//                    Greeting(
//                        name = "Android",
//                        modifier = Modifier.padding(innerPadding)
//                    )
//                }
//            }
//        }
    }
}

@Composable
fun AccueilMultiple(names: List<String>) {
    Column {
        for (name in names) {
            Text(text = "Bonjour $name !", modifier = Modifier.padding(4.dp))
        }
    }
}
@Preview
@Composable
fun AccueilMultiplePreview() {
    AccueilMultiple(listOf("pierre", "paul", "jacques"))
}

//@Composable
//fun Accueil(name: String) {
//    ElevatedCard {
//        Column(
//            horizontalAlignment = Alignment.CenterHorizontally,
//            modifier = Modifier
//                .fillMaxWidth()
//                .padding(8.dp)
//
//        ) {
//            Text(text = "Bonjour $name", fontSize=20.sp)
//            Text(text = "Je vois de grands progrès", color = Color.Blue)
//        }
//    }
//}
//
//@Composable
//fun Accueil(name: String, modifier: Modifier = Modifier) {
//    ElevatedCard {
//        Column(
//            modifier = modifier.padding(8.dp),
//            horizontalAlignment = Alignment.CenterHorizontally
//        ) {
//            Text(
//                text = "Bonjour $name",
//                fontSize = 20.sp,
//                modifier = Modifier.padding(12.dp))
//            Text(text = "Je vois de grands progrès", color = Color.Blue)
//        };
//    }
//}
//@Preview
//@Composable
//fun AccueilPreview() {
//    Column {
//        Accueil(name = "numéro 10", modifier = Modifier.fillMaxWidth())
//        Accueil(name = "numéro 6") // valeur par défaut du modifier
//    }
//}

//@Composable
//fun Accueil(name: String) {
//    ElevatedCard {
//        Text(text = "Bonjour $name", fontSize=20.sp)
//        Text(text = "Je vois de grands progrès", color = Color.Blue)
//    }
//}

//@Composable
//fun Accueil(name: String) {
//    Column(content = {
//        Text(text = "Bonjour $name", fontSize=20.sp)
//        Text(text = "Je vois de grands progrès", color = Color.Blue)
//    })
//}

//@Composable
//fun Accueil(name: String) {
//    Column {
//        Text(text = "Bonjour $name", fontSize = 20.sp)
//        Text(text = "Je vois de grands progrès", color = Color.Blue)
//    }
//}

//@Composable
//fun Accueil(name: String) {
//    Text(text = "Bonjour $name", fontSize=20.sp)
//    Text(text = "Je vois de grands progrès", color = Color.Blue)
//}

//@Composable
//fun Accueil(name: String) {
//    Text(text = "Bonjour $name", fontSize=20.sp)
//}

@Composable
fun Greeting(name: String, modifier: Modifier = Modifier) {
    Text(
        text = "Hello $name!",
        modifier = modifier
    )
}

@Preview(showBackground = true)
@Composable
fun GreetingPreview() {
    JetpackcomposepracticeTheme {
        Greeting("Android")
    }
}