import { describe, expect, beforeAll, test } from '@jest/globals';
import Pet from '../../src/models/Pet';

describe('Testing Pet class', () => {
  describe('Normal creation', () => {
    let cat: Pet;
    beforeAll(() => {
      cat = new Pet(1, 'Donkey', 'cat', new Date('2013-01-01T00:00:00Z'));
    });
    test('should create a cat', () => {
      expect(cat).toBeInstanceOf(Pet);
    });
  });
  describe('JSON representation', () => {
    let pet: Pet;
    let json: object;
    beforeAll(() => {
      pet = new Pet(2, 'Pastèque', 'dog', new Date('2020-08-07T00:00:00Z'));
      json = pet.toJSON();
    });
    test('Generate JSON', () => {
      expect(json).toBeInstanceOf(Object);
    });
  });
  describe('Get age', () => {
    let pasteque: Pet;
    beforeAll(() => {
      pasteque = new Pet(1, 'Pastèque', 'dog', new Date('2020-08-07'));
    });
    test('Birth date forward', () => {
      expect(pasteque.getAge()).toBe(2);
    });
  });
});
