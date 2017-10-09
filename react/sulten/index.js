import React, {Component} from 'react'
import ReactDOM from 'react-dom'
import './sulten.css'
import './stepbar.css'
import axios from 'axios'
import moment from 'moment'

function StepViewer(props){
  console.log(props)
  var s1,s2,s3;
  s1 = s2 = s3 = "step"
  const current = "step current"
  switch (props.step) {
    case 1:
      s1 = current
      break
    case 2:
      s2 = current
      break
    case 3:
      s3 = current
      break
    default:
      s1 = current
      break
  }
  return (
    <ol className="stepBar step3">
      <li className={s1}>Info</li>
      <li className={s2}>Tid</li>
      <li className={s3}>Bekreft</li>
    </ol>
  )
}

class SultenForm extends Component {
  constructor () {
    super()
    this.state = {
      step: 0,
      available_times: [],
      duration: 30,
      type: 'drikke',
    }
  }

  async getAvailableTimes () {
    try {
      console.log(moment(this.state.date));
      const res = await axios.get('/lyche/available', {
        params: {
          date: moment(this.state.date, "Europe/Oslo").toJSON(),
          duration: this.state.duration,
          people: this.state.people,
          type_id: 1
        }
      })
      console.log(res)
      this.setState({available_times: res.data.map(time => moment(time))})
      this.nextStep()
    } catch (err) {
      console.log(err)
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
          For å lage en reservasjon hos lyche, vennligst fyll ut og send inn skjemaet under.

          Foreløpig kan en bare reservere bord mellom kl. 16:00 - 22:00 og reservasjonen må gjøres minst ett døgn i forveien.

          For å endre eller avbestille en reservasjon, vennligst send mail til lyche.
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
        <form onSubmit={e => e.preventDefault()}>
          <ul id='sulten-form-flex'>
            <li>
              <label htmlFor='name'>Navn</label>
              <input type='text' name='name' value={this.state.name} onChange={e => this.handleFormChange('name', e.target.value)} required />
            </li>
            <li>
              <label htmlFor='email'>E-post</label>
              <input type='email' name='email' value={this.state.email} onChange={e => this.handleFormChange('email', e.target.value)} required />
            </li>
            <li>
              <label htmlFor='people'>Antall</label>
              <input type='number' name='people' value={this.state.people} onChange={e => this.handleFormChange('people', e.target.value)} required min="1" step="1" max="12" />
            </li>
            <li>
              <label htmlFor='date'>Dato</label>
              <input type='date' name='date'
                value={this.state.date}
                onChange={e =>
                    this.handleFormChange(
                      'date', e.target.value)} required
              />
            </li>
            <li>
              <label htmlFor='duration'>Varighet</label>
              <select name='duration' onChange={e => this.handleFormChange('duration', e.target.value)} required >
                <option value='30'>30m</option>
                <option value='60'>1t</option>
                <option value='90'>1t 30m</option>
                <option value='120'>2t</option>
              </select>
            </li>
            <li>
              <label htmlFor='type'>Type</label>
              <select name='type' onChange={e => this.handleFormChange('type', e.target.value)} required >
                <option value='drikke'>Drikke</option>
                <option value='mat'>Mat</option>
              </select>
            </li>
          </ul>
          <div id='sulten-actions'>
            <input type='submit' value='Forrige' onClick={() => this.prevStep()} />
            <input type='submit' value='Neste' onClick={() => this.validInput() ? this.getAvailableTimes() : console.log("badForm")} />
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
        <p>
          {moment(this.state.date).format("DD/MM/YY")}
        </p>
        <div id='sulten-times'>
          {this.state.available_times.map((time) => (
            <button key={time} className='sulten-time' onClick={() => this.selectTime(time)}>{moment(time).format("HH:mm")}</button>
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
        <ul id='sulten-form-flex'>
          <li>
            <label>Navn</label>
            <p>{this.state.name}</p>
          </li>
          <li>
            <label>Epost</label>
            <p>{this.state.email}</p>
          </li>
          <li>
            <label>Antall</label>
            <p>{this.state.people}</p>
          </li>
          <li>
            <label>Dato</label>
            <p>{this.state.date}</p>
          </li>
          <li>
            <label>Fra</label>
            <p>{moment(this.state.time).format("HH:mm")}</p>
          </li>
          <li>
            <label>Til</label>
            <p>{moment(this.state.time).add(this.state.duration, 'm').format("HH:mm")}</p>
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
        return (
          <div className="step-view">
            {this.stepZero()}
          </div>
        )
      case 1:
        return (
          <div className="step-view">
            <StepViewer step={1} />
            {this.stepOne()}
          </div>
        )
      case 2:
        return (
          <div className="step-view">
            <StepViewer step={2} />
            {this.stepTwo()}
          </div>
        )
      case 3:
        return (
          <div className="step-view">
            <StepViewer step={3} />
            {this.stepThree()}
          </div>
        )
      case 4:
        return (
          <div className="step-view">
            {this.stepFour()}
          </div>
        )
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
