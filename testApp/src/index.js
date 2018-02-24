import './main.css';
import { Main } from './Main.elm';
import registerServiceWorker from './registerServiceWorker';

const storageKey = 'elm-mastodon-testapp'

const storedModel = window.localStorage.getItem(storageKey)

const app = Main.embed(document.getElementById('root'), storedModel);
app.ports.saveToLocalStorage.subscribe(value => window.localStorage.setItem(storageKey, value))

registerServiceWorker();
