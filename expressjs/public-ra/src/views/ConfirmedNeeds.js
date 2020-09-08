import React from 'react';
import { useState, useEffect } from 'react';
import { Link, Redirect } from 'react-router-dom';

function ConfirmedNeeds() {
    const [confirmedNeeds, setConfirmedNeeds] = useState([]);

    useEffect(() => {
        fetch("http://localhost:8080/api/confirmed_needs")
            .then((res) => {
                return res.json();
            })
            .then((data) => {
                setConfirmedNeeds(data);
            })
            .catch((err) => {
                console.log(err);
            });
    }, []);

    const editConfirmedNeed = (id) => {
        let myPath = '/confirmed_need/edit/' + id + '';
        return myPath
    }

    if (confirmedNeeds) {
        return (
            <div className="container text-center" >
                <div className="bg-dblue rounded">
                    <h1 className="mt-5 c-white p-3">Approved Needs</h1>
                </div>
                <div className="bg-blue p-2 mt-2 rounded border">
                    <div className="bg-white rounded">
                        <table className="table mt-3 rounded">
                            <thead className="thead-dark rounded">
                                <tr>
                                    <th scope="col">#</th>
                                    <th scope="col">Name</th>
                                    <th scope="col">Surname</th>
                                    <th scope="col">Need Type</th>
                                    <th scope="col">Amount</th>
                                    <th scope="col">Approver Name</th>
                                    <th scope="col">Approver NGO</th>
                                    <th scope="col">Urgency</th>
                                    <th scope="col">Status</th>
                                    <th scope="col">Phone</th>
                                    <th scope="col">Address</th>
                                    <th scope="col"></th>
                                </tr>
                            </thead>
                            <tbody>
                                {confirmedNeeds.map(need =>
                                    <tr id={need.id}>
                                        <th scope="row">{need.id}</th>
                                        <td>{need.name}</td>
                                        <td>{need.surname}</td>
                                        <td>{need.needType}</td>
                                        <td>{need.amount}</td>
                                        <td className="row text-center"><span>{need.confirmName}</span><span>{need.confirmSurname}</span></td>
                                        <td>{need.confirmSTK}</td>
                                        <td>{need.urgency}</td>
                                        <td>{need.status}</td>
                                        <td>{need.phone}</td>
                                        <td>{need.address}</td>
                                        <td>
                                            <Link to={editConfirmedNeed(need.id)} className="mybtn-edit">Edit</Link>
                                        </td>
                                    </tr>
                                )}
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        )
    } else {
        return <Redirect to='/' />
    }
}

export default ConfirmedNeeds;