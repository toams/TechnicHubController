#include "connector.h"

Connector::Connector(FavoriteDevices *f)
{
    favDev = f;
}

Connector::~Connector()
{
     favDev = nullptr;
     for(int i = 0; i < connectedDevicesList.count(); i++){
         delete connectedDevicesList[i];
     }
}

void Connector::setFoundList(QList<QBluetoothDeviceInfo> &list)
{
    if(!foundList.isEmpty())foundList.clear();
    foundList = list;
}

void Connector::connectDevice(QString address)
{
    int counter = 0;
    for(QBluetoothDeviceInfo d : foundList){
        if(d.address().toString() == address){           
            connectedDevicesList.push_back(new Technichub());
            connectedDevicesList[connectedDevicesList.count()-1]->setFactoryName(d.name());
            connectedDevicesList[connectedDevicesList.count()-1]->tryConnect(d);
            connect(connectedDevicesList[connectedDevicesList.count()-1], &Technichub::successConnected, [=](){ getConnectedParam(); });
            connect(connectedDevicesList[connectedDevicesList.count()-1], &Technichub::lostConnection, this, &Connector::qmlDisconnected);
            connect(connectedDevicesList[connectedDevicesList.count()-1], &Technichub::lostConnection, this, &Connector::deviceDisconnected);
            connect(connectedDevicesList[connectedDevicesList.count()-1], &Technichub::paramsChanged, this, &Connector::deviceParamsChanged);
            connect(connectedDevicesList[connectedDevicesList.count()-1], &Technichub::externalPortsIOchanged, this, &Connector::externalPortsIOchanged);
            connect(connectedDevicesList[connectedDevicesList.count()-1], &Technichub::tiltDegreesChanged, this, &Connector::tiltDegreesChanged);
        }
        counter++;
    }
}

bool Connector::disconnectDevice(QString address)
{
    int counter = 0;
    for(Technichub *t : connectedDevicesList){
        if(t->getAddress() == address){
            connectedDevicesList[counter]->disconnect();
        }
        counter++;
    }
    return false;
}

void Connector::updateConnectedDeviceName(QString address, QString name)
{
    int counter = 0;
    for(Technichub *t : connectedDevicesList){
        if(t->getAddress() == address){
            connectedDevicesList[counter]->setName(name);
            emit devicesChanged(connectedDevicesList);
        }
        counter++;
    }
}

void Connector::deleteFromList(QString address)
{
    int counter = 0;
    for(Technichub *t : connectedDevicesList){
        if(t->getAddress() == address && !t->isConnected()){
            delete connectedDevicesList[counter];
            connectedDevicesList.remove(counter);
        }
        counter++;
    }
}

QList<bool> Connector::getHubPortsState(QString address)
{
    int counter = 0;
    for(Technichub *t : connectedDevicesList){
        if(t->getAddress() == address){
            return connectedDevicesList[counter]->getPortsState();
        }
        counter++;
    }
    QList<bool> zero;
    return zero;
}

void Connector::getConnectedParam()
{
    QStringList list;

    list.append(QString::number(connectedDevicesList.count()-1));
    list.append(QString::number(connectedDevicesList[connectedDevicesList.count()-1]->getType()));

    if(favDev->isFavorite(connectedDevicesList[connectedDevicesList.count()-1]->getAddress())){
        connectedDevicesList[connectedDevicesList.count()-1]->setName(favDev->getName(connectedDevicesList[connectedDevicesList.count()-1]->getAddress()));
    }

    list.append(connectedDevicesList[connectedDevicesList.count()-1]->getName());
    list.append(connectedDevicesList[connectedDevicesList.count()-1]->getAddress());
    list.append(connectedDevicesList[connectedDevicesList.count()-1]->getFactoryName());

    emit connected();
    emit newDeviceAdded(list);
    emit devicesChanged(connectedDevicesList);
}

void Connector::deviceDisconnected(QString address)
{
    int counter = 0;
    for(Technichub *t : connectedDevicesList){
        if(t->getAddress() == address){
            delete connectedDevicesList[counter];
            connectedDevicesList.remove(counter);
            emit devicesChanged(connectedDevicesList);
        }
        counter++;
    }
}
