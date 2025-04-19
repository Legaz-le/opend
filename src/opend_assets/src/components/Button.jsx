import React from "react";

function Button(props) {
    return (
        <div className="Chip-root makeSyles-chipBlue-108 Chip-clickable">
            <span
            onClick={props.handleClick} className="form-Chip-label">
            {props.text}
            </span>
        </div> 
    );
}

export default Button;