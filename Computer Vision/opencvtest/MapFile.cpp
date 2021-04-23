#include "MapFile.h"

MapFileMaster::MapFileMaster(char const* filename, size_t bufSize) {
	this->mapFile = CreateFileMappingA(INVALID_HANDLE_VALUE, NULL, PAGE_READWRITE, 0, bufSize, filename);
	if (this->mapFile == NULL) {
		std::cout << "Error CreateFileMapping" << std::endl;
		return;
	}
	this->data = (int*)MapViewOfFile(this->mapFile, FILE_MAP_ALL_ACCESS, 0, 0, bufSize);
	if (this->data == NULL) {
		std::cout << "Error MapViewOfFile" << std::endl;
		return;
	}
	for (size_t i = 0; i < 5; i++) {
		data[i] = 0;
	}
}

void MapFileMaster::SetData(int x, int y, int angle) {
	this->data[0] = x;
	this->data[1] = y;
	this->data[2] = angle;
}

void MapFileMaster::SetPath(std::vector<std::array<int, 2>> path) {
	this->data[3] = path.size();
	for (size_t i = 0; i < path.size(); i++) {
		data[4 + i * 2] = path[i][0];
		data[4 + i * 2 + 1] = path[i][1];
	}
}

int MapFileMaster::GetPath(std::vector<std::array<int, 2>> & path) {
	if (this->data[3] == 0) {
		return 0;
	}
	path.resize(this->data[3]);
	for (size_t i = 0; i < path.size(); i++) {
		path[i][0] = this->data[4 + i * 2];
		path[i][1] = this->data[4 + i * 2 + 1];
	}
	return 1;
}

MapFileMaster::~MapFileMaster() {
	UnmapViewOfFile(this->data);
	CloseHandle(this->mapFile);
}

MapFileSlave::MapFileSlave(char const* filename, size_t bufSize) {
	this->mapFile = OpenFileMappingA(FILE_MAP_ALL_ACCESS, FALSE, filename);
	if (this->mapFile == NULL) {
		std::cout << "Error OpenFileMapping" << std::endl;
		return;
	}
	this->data = (int*)MapViewOfFile(this->mapFile, FILE_MAP_ALL_ACCESS, 0, 0, bufSize);
	if (this->data == NULL) {
		std::cout << "Error MapViewOfFile" << std::endl;
		return;
	}
}

void MapFileSlave::GetData(int& x, int& y, int& angle) {
	x = this->data[0];
	y = this->data[1];
	angle = this->data[2];
}

void MapFileSlave::GetPath(std::vector<std::array<int, 2>> & path) {
	if (this->data[3] == 0) {
		std::cout << "No path provided" << std::endl;
		return;
	}
	path.resize(this->data[3]);
	for (size_t i = 0; i < path.size(); i++) {
		path[i][0] = this->data[4 + i * 2];
		path[i][1] = this->data[4 + i * 2 + 1];
	}
}

void MapFileSlave::SetPath(std::vector<std::array<int, 2>> path) {
	this->data[3] = path.size();
	for (size_t i = 0; i < path.size(); i++) {
		data[4 + i * 2] = path[i][0];
		data[4 + i * 2 + 1] = path[i][1];
	}
}


MapFileSlave::~MapFileSlave() {
	UnmapViewOfFile(this->data);
	CloseHandle(this->mapFile);
}