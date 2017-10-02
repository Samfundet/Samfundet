import React, {Component} from 'react'
import ReactDOM from 'react-dom'
import './sulten.css'

class SultenForm extends Component {
  constructor () {
    super()
    this.state = {
      step: 0,
      available_times: ['16:00', '16:30', '17:00', '17:30'],
      duration: 30,
      type: 'drikke'
    }
  }

  nextStep () {
    this.setState({step: this.state.step >= 4 ? 4 : this.state.step + 1})
  }

  prevStep () {
    this.setState({step: this.state.step <= 0 ? 0 : this.state.step - 1})
  }

  handleFormChange (field, value) {
    this.setState({[field]: value})
  }

  validInput () {
    return this.state.email && this.state.email !== '' && this.state.duration && this.state.duration !== '' && this.state.date && this.state.date !== ''
  }

  stepZero () {
    return (
      <div id='sulten-container'>
        <h2>
          Velkommen til Lyche sitt nye bordbestillingssystem
        </h2>
        <span id='sulten-body'>
          FOR Å LAGE EN RESERVASJON HOS LYCHE, VENNLIGST FYLL UT OG SEND INN SKJEMAET UNDER.

          FORELØPIG KAN EN BARE RESERVERE BORD MELLOM KL. 16:00 - 22:00 OG RESERVASJONEN MÅ GJØRES MINST ETT DØGN I FORVEIEN.

          FOR Å ENDRE ELLER AVBESTILLE EN RESERVASJON, VENNLIGST SEND MAIL TIL LYCHE.
        </span>
        <div id='sulten-actions'>
          <input type='submit' value='Start' onClick={() => this.nextStep()} />
        </div>
      </div>
    )
  }

  stepOne () {
    return (
      <div id='sulten-container'>
        <h2>
          Fyll inn skjemaet for å gå videre i bestillingen
        </h2>
        <form onSubmit={() => this.validInput() ? this.nextStep() : console.log("badForm")}>
          <ul id='sulten-form-flex'>
            <li>
              <label for='email'>E-post</label>
              <input type='email' name='email' value={this.state.email} onChange={e => this.handleFormChange('email', e.target.value)} required />
            </li>
            <li>
              <label for='participants'>Antall</label>
              <input type='number' name='participants' value={this.state.participants} onChange={e => this.handleFormChange('participants', e.target.value)} required min="1" step="1" max="12" />
            </li>
            <li>
              <label for='date'>Dato</label>
              <input type='date' name='date' value={this.state.date} onChange={e => this.handleFormChange('date', e.target.value)} required />
            </li>
            <li>
              <label for='duration'>Varighet</label>
              <select name='duration' onChange={e => this.handleFormChange('duration', e.target.duration)} required >
                <option value='30'>30m</option>
                <option value='60'>1t</option>
                <option value='90'>1t 30m</option>
                <option value='120'>2t</option>
              </select>
            </li>
            <li>
              <label for='type'>Type</label>
              <select name='type' onChange={e => this.handleFormChange('type', e.target.value)} required >
                <option value='drikke'>Drikke</option>
                <option value='mat'>Mat</option>
              </select>
            </li>
          </ul>
          <div id='sulten-actions'>
            <input type='submit' value='Forrige' onClick={() => this.prevStep()} />
            <input type='submit' value='Neste' onClick={() => this.validInput() ? this.nextStep() : console.log("badForm")} />
          </div>
        </form>
      </div>
    )
  }

  selectTime (time) {
    this.setState({time: time})
    this.nextStep()
  }

  stepTwo () {
    return (
      <div id='sulten-container'>
        <h2>
          Velg tid som passer deg best
        </h2>
        <div id='sulten-times'>
          {this.state.available_times.map((time) => (
            <button key={time} className='sulten-time' onClick={() => this.selectTime(time)}>{time}</button>
          ))}
        </div>
        <div id='sulten-actions'>
          <input type='submit' value='Forrige' onClick={() => this.prevStep()} />
        </div>
      </div>
    )
  }

  stepThree () {
    return (
      <div id='sulten-container'>
        <h2>
          Bekreft din bestilling
        </h2>
        <ul id='sulten-form-flex'>
          <li>
            <label>Epost</label>
            <p>{this.state.email}</p>
          </li>
          <li>
            <label>Antall</label>
            <p>{this.state.participants}</p>
          </li>
          <li>
            <label>Tidspunkt</label>
            <p>{this.state.time}</p>
          </li>
          <li>
            <label>Varighet</label>
            <p>{this.state.duration}</p>
          </li>
          <li>
            <label>Type</label>
            <p>{this.state.type}</p>
          </li>
        </ul>
        <div id='sulten-actions'>
          <input type='submit' value='Forrige' onClick={() => this.prevStep()} />
          <input type='submit' value='Bestill' onClick={() => this.nextStep()} />
        </div>
      </div>
    )
  }

  stepFour () {
    return (
      <div id='sulten-container'>
        <h2>
          Bekreftelse
        </h2>
        EPOST SENDT
        BEKREFTELSESDATA
        WOW
        SUCH CONFIRM. Bestille på nytt?
        <div id='sulten-actions'>
          <input type='submit' value='Begynn på nytt' onClick={() => this.setState({step: 1})} />
        </div>
      </div>
    )
  }

  renderStep () {
    switch (this.state.step) {
      case 0:
        return this.stepZero()
      case 1:
        return this.stepOne()
      case 2:
        return this.stepTwo()
      case 3:
        return this.stepThree()
      case 4:
        return this.stepFour()
    }
  }

  render () {
    return this.renderStep()
  }
}

ReactDOM.render(
  <SultenForm />,
  document.getElementById('sulten')
)
