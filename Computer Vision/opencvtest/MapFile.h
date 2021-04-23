#ifndef MAP_FILE_H
#define MAP_FILE_H

#include <Windows.h>
#include <iostream>
#include <array>
#include <vector>

struct MapFileMaster {
	MapFileMaster(char const* filename, size_t bufSize);
	void SetData(int x, int y, int angle);
	void SetPath(std::vector<std::array<int, 2>> path);
	int GetPath(std::vector<std::array<int, 2>> & path);

	~MapFileMaster();
private:
	HANDLE mapFile;
	int* data;
};

struct MapFileSlave {
	MapFileSlave(char const* filename, size_t bufSize);
	void GetData(int& x, int& y, int& angle);
	void GetPath(std::vector<std::array<int, 2>> & path);
	void SetPath(std::vector<std::array<int, 2>> path);
	~MapFileSlave();
private:
	HANDLE mapFile;
	int* data;
};

#endif