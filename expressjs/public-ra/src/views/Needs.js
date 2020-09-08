import React from 'react';
import { useState, useEffect } from 'react';
import { Link, Redirect } from 'react-router-dom';

function Needs() {
    const [needs, setNeeds] = useState([]);

    useEffect(() => {
        fetch("http://localhost:8080/api/needs")
            .then((res) => {
                return res.json();
            })
            .then((data) => {
                setNeeds(data);
            })
            .catch((err) => {
                console.log(err);
            });
    }, []);

    const editNeed = (id) => {
        let myPath = '/need/edit/' + id + '';
        return myPath;
    }

    const delNeed = (id) => {
        let myPath = '/api/need/delete/' + id + '';
        return myPath
    }

    if (needs) {
        return (
            <div className="container text-center" >
                <div className="bg-dblue rounded">
                    <h1 className="mt-5 c-white p-3">Needs</h1>
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
                                    <th scope="col">Phone</th>
                                    <th scope="col">Address</th>
                                    <th scope="col"></th>
                                    <th scope="col"></th>
                                </tr>
                            </thead>
                            <tbody>
                                {needs.map(need =>
                                    <tr id={need.id}>
                                        <th scope="row">{need.id}</th>
                                        <td>{need.name}</td>
                                        <td>{need.surname}</td>
                                        <td>{need.needType}</td>
                                        <td>{need.amount}</td>
                                        <td>{need.phone}</td>
                                        <td>{need.address}</td>
                                        <td>
                                            <Link to={editNeed(need.id)} className="mybtn-edit">Edit</Link>
                                        </td>
                                        <td>
                                            <a href={delNeed(need.id)} className="mybtn-danger">Delete</a>
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

export default Needs;