// Simplified blockchain implementation
// https://jeiwan.net/posts/building-blockchain-in-go-part-1/
package main

import (
	"bytes"
	"crypto/sha256"
	"fmt"
	"strconv"
	"time"
)

type Block struct {
	Timestamp    int64
	Data         []byte
	PreviousHash []byte
	Hash         []byte
}

func NewBlock(data string, previousHash []byte) *Block {
	block := &Block{time.Now().Unix(), []byte(data), previousHash, []byte{}}
	block.ComputeHash()

	return block
}

func (b *Block) ComputeHash() {
	timestamp := []byte(strconv.FormatInt(b.Timestamp, 10))
	headers := bytes.Join([][]byte{b.PreviousHash, b.Data, timestamp}, []byte{})
	hash := sha256.Sum256(headers)

	b.Hash = hash[:]
}

type Blockchain struct {
	blocks []*Block
}

func (bc *Blockchain) AddBlock(data string) {
	previousBlock := bc.blocks[len(bc.blocks)-1]
	newBlock := NewBlock(data, previousBlock.Hash)
	bc.blocks = append(bc.blocks, newBlock)
}

func NewBlockchain() *Blockchain {
	return &Blockchain{
		[]*Block{
			NewBlock("first", []byte{}),
		},
	}
}

func main() {
	bc := NewBlockchain()
	bc.AddBlock("second block")

	for _, block := range bc.blocks {
		fmt.Printf("Previous hash: %x\n", block.PreviousHash)
		fmt.Printf("Data: %s\n", block.Data)
		fmt.Printf("Hash: %x\n\n", block.Hash)
	}
}
