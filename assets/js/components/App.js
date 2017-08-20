import React from 'react'
import axios from 'axios'

class App extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      loading: true,
      messages: [],
      currentMessageIndex: null
    }
    this.changeIndex = this.changeIndex.bind(this)
  }

  componentDidMount() {
    axios.get('/api/commit_messages').then((data) => {
      const messages = data.data.data
      this.setState({
        messages: messages,
        currentMessageIndex: this.generateRandomNumber(messages),
        loading: false
      })
    })
  }

  generateRandomNumber(messages) {
   return Math.floor(Math.random() * messages.length)
  }

  changeIndex() {
    this.setState({currentMessageIndex: this.generateRandomNumber(this.state.messages) })
  }

  render() {
    if (this.state.loading){ return (<div>Loading</div>) }

    return(
      <div>
        <h1>{ this.state.messages[this.state.currentMessageIndex].content }</h1>
        <button onClick={this.changeIndex}>Regenerate</button>
      </div>
    )

  }
}

export default App
