
CREATE TABLE Clients (
    client_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100)
);

CREATE TABLE Devices (
    device_id INT PRIMARY KEY,
    client_id INT NOT NULL,
    model VARCHAR(100) NOT NULL,
    serial_number VARCHAR(50) UNIQUE NOT NULL,
    FOREIGN KEY (client_id) REFERENCES Clients(client_id)
);


CREATE TABLE Masters (
    master_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100)
);


CREATE TABLE Faults (
    fault_id INT PRIMARY KEY,
    description TEXT NOT NULL
);

CREATE TABLE RepairRequests (
    request_id INT PRIMARY KEY,
    device_id INT NOT NULL,
    fault_id INT NOT NULL,
    master_id INT NOT NULL,
    request_date DATE NOT NULL,
    status VARCHAR(50),
    notes TEXT,
    FOREIGN KEY (device_id) REFERENCES Devices(device_id),
    FOREIGN KEY (fault_id) REFERENCES Faults(fault_id),
    FOREIGN KEY (master_id) REFERENCES Masters(master_id)
);
