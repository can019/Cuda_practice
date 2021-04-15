OBJECTS = DS_timer.o base.o

CC=nvcc
CFLAGS = -g
TARGET = base

$(TARGET) :$(OBJECTS)
	$(CC) -o $(TARGET) $(OBJECTS)

DS_timer.o : DS_timer.cpp DS_timer.h DS_definitions.h
base.o : base.cu

clean :
	rm -rf $(OBJECTS)
	rm $(TARGET)
