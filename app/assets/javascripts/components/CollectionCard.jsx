class CollectionCard extends React.Component {
  render() {
    let classes = 'card-container '
    classes += this.props.expanded == this.props.index ? ' expanded' : ''
    let sty = {backgroundImage: 'url(' + this.props.cardImage + ')'}

    let programNumber, date, description

    if(this.props.programNumber){
      programNumber = "Program " + this.props.programNumber
    }

    if(this.props.date){
      date = "(" + this.props.date + ")"
    }

    pnAndDate = ( <div className="card-text">{ programNumber } { date }</div> )

    if(this.props.description){
      description = ( <div className="card-text">{ this.props.description }</div> )
    }

    return (
      <div style={ sty } onClick={ () => this.props.expand(this.props.index) } className={ classes }>
        <div className="card-container-mask"></div>

        <h1 className="card-title">
          { this.props.title }
        </h1>

        { pnAndDate }

        { description }

        <a href={ this.props.recordLink } className="card-showfull">
          See Full Record
        </a>
      </div>
    )
  }
}
