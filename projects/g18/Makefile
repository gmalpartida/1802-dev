AS=/opt/ASxxxx/bin/as1802
LD=/opt/ASxxxx/bin/aslink
VI=vi
HEXDUMP=hexdump
UCSIM=/opt/sdcc/bin/ucsim_z80
OBJCOPY=/opt/sdcc/bin/sdobjcopy
SOCAT=socat
MINICOM=minicom
SCREEN=screen
MINIPRO=minipro

include sources.mk

TARGET=$(notdir $(CURDIR))
ROM= "AT28C64B"

SRC_DIR=src
BIN_DIR=bin
INC_DIR=inc
CFG_DIR=cfg

IHX_FILE=$(BIN_DIR)/$(TARGET).ihx
MAP_FILE=$(BIN_DIR)/$(TARGET).map
LD_FILE=$(CFG_DIR)/$(TARGET).ld
BIN_FILE=$(BIN_DIR)/$(TARGET).bin
SRC_FILE=$(SRC_DIR)/$(TARGET).asm
UC_SIM_FILE=$(CFG_DIR)/$(TARGET).ucsim

RELS = $(patsubst $(SRC_DIR)/%.asm, $(BIN_DIR)/%.rel, $(SRCS))

AS_FLAGS= -losz
LD_FLAGS=-imjwz -b _CODE=0x0000 -b _DATA=0X2000 

OBJCOPY_FLAGS= -I ihex -O binary $(IHX_FILE)
HEXDUMP_FLAGS=-C
UCSIM_FLAGS= -t z80 -C $(UC_SIM_FILE) -X 8.192M
MINICOM_FLAGS=-D /dev/ttyUSB0 -b 57600
MINIPRO_FLAGS= -p $(ROM) -w $(BIN_FILE)

# Update your main target to depend on the final output
.PHONY: all link build edit dump clean sim bridge uart screen
all: link
	$(OBJCOPY) $(OBJCOPY_FLAGS) $(BIN_FILE)

$(BIN_DIR)/%.rel : $(SRC_DIR)/%.asm
	$(AS) $(AS_FLAGS) $@ $<
 
build : $(RELS)

$(IHX_FILE): $(RELS)
	@mkdir -p $(dir $@)
	$(LD) $(LD_FLAGS) $(IHX_FILE) $(RELS)

link: $(IHX_FILE)

edit:
	$(VI) $(SRC_FILE)

dump: link
	$(HEXDUMP) $(HEXDUMP_FLAGS) $(BIN_FILE)

sim: link
	$(UCSIM) $(UCSIM_FLAGS) $(IHX_FILE)

uart: link
	$(MINICOM) $(MINICOM_FLAGS) 

flash:
	$(MINIPRO) $(MINIPRO_FLAGS) 

test:
	$(AS) $(AS_FLAGS) -L bin/test.lst -o bin/test.obj src/test.asm
	$(AS) $(AS_FLAGS) -L bin/parser_cmd_line.lst -o bin/parser_cmd_line.obj src/parser_cmd_line.asm
	$(AS) $(AS_FLAGS) -L bin/string.lst -o bin/string.obj src/string.asm
	$(AS) $(AS_FLAGS) -L bin/convert.lst -o bin/convert.obj src/convert.asm
	$(LD) -T$(LD_FILE) -bihex -obin/test.ihx bin/test.obj bin/parser_cmd_line.obj bin/string.obj bin/convert.obj -M > bin/test.map
	$(UCSIM) $(UCSIM_FLAGS) bin/test.ihx

clean: 
	rm -f $(BIN_DIR)/*

