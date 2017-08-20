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
    if (this.state.loading){
      return (
        <div className="spinner">
          <div className="rect1"></div>
          <div className="rect2"></div>
          <div className="rect3"></div>
          <div className="rect4"></div>
          <div className="rect5"></div>
        </div>
      )
    }

    return(
      <div className='level level--padding-tall' onClick={this.changeIndex}>
        <h2 className='heading heading--level-1 util--text-align-c hoverable'>{ this.state.messages[this.state.currentMessageIndex].content }</h2>
      </div>
    )

  }
}

export default App
