

$(document).ready(function() {

  $("#spellsheet").on("mouseenter", ".memorization_spell", function() {
    $(this).find(".spell_controls").show();
  });

  $("#spellsheet").on("mouseleave", ".memorization_spell", function() {
    $(this).find(".spell_controls").hide();
  });
});


// ========================================
// SpellSheetModel
// ========================================
function SpellSheetModel(data) {
  this.sections = ko.observableArray();
  this.libraryIdValue = data.library_id;
  this.modeValue = data.mode;

  var spells = data.spells;

  for (var x = 0; x < spells.length; x++) {
    this.addSpell(spells[x]);
  }

  this.sort();

  this.sectionSortFunction = function(left, right) {
    if (left.section() == right.section()) {
      return 0;
    }

    return left.section() < right.section() ? -1 : 1;
  };
}

SpellSheetModel.prototype.libraryId = function() {
  return this.libraryIdValue;
};

SpellSheetModel.prototype.mode = function() {
  return this.modeValue;
};

SpellSheetModel.prototype.addSpell = function(spell) {
  var section = null;
  for (var x = 0; x < this.sections().length; x++) {
    if (this.sections()[x].section() == spell.section) {
      section = this.sections()[x];
      break;
    }
  }

  if (section == null) {
    section = new SectionModel(spell.section, this);
    this.sections.push(section);
  }

  section.addSpell(spell);
};

SpellSheetModel.prototype.sort = function() {
  this.sections.sort(this.sectionSortFunction);
  _.each(this.sections(), function(s) {
    s.sort();
  });
};


// ========================================
// SectionModel
// ========================================
function SectionModel(section, container) {
  this.container = container;
  this.section = ko.observable(section);
  this.levels = ko.observableArray();

  this.levelSortFunction = function(left, right) {
    if (left.level() == right.level()) {
      return 0;
    }

    return left.level() < right.level() ? -1 : 1;
  };
}

SectionModel.prototype.libraryId = function() {
  return this.container.libraryId();
};

SectionModel.prototype.mode = function() {
  return this.container.mode();
};

SectionModel.prototype.addSpell = function(spell) {
  var level = null;
  for (var x = 0; x < this.levels().length; x++) {
    if (this.levels()[x].level() == spell.level) {
      level = this.levels()[x];
      break;
    }
  }

  if (level == null) {
    level = new LevelModel(spell.level, this);
    this.levels.push(level);
  }

  level.addSpell(spell);
};

SectionModel.prototype.sort = function() {
  this.levels.sort(this.levelSortFunction);
  _.each(this.levels(), function(l) {
    l.sort();
  });
};


// ========================================
// LevelModel
// ========================================
function LevelModel(level, container) {
  this.container = container;
  this.level = ko.observable(level);
  this.spells = ko.observableArray();

  this.spellSortFunction = function(left, right) {
    if (left.key == right.key) {
      return 0;
    }

    return left.name() < right.name() ? -1 : 1;
  };
}

LevelModel.prototype.libraryId = function() {
  return this.container.libraryId();
};

LevelModel.prototype.mode = function() {
  return this.container.mode();
};

LevelModel.prototype.addSpell = function(spell) {
  this.spells.push(new SpellModel(spell, this));
};

LevelModel.prototype.sort = function() {
  this.spells.sort(this.spellSortFunction);
};


// ========================================
// SpellModel
// ========================================
function SpellModel(spell, container) {
  this.container = container;
  this.key = spell.key;
  this.section = spell.section;
  this.level = spell.level;
  this.spellId = spell.spell_id;
  this.memorizedId = spell.memorized_spell_id;

  this.isLearned = ko.observable();
  this.numberMemorized = ko.observable();
  this.name = ko.observable();
  this.components = ko.observable();
  this.school = ko.observable();
  this.description = ko.observable();

  this.update(spell);

  this.detailsUrl = ko.computed(function() {
    if (this.spellId) {
      return getContextRoot() + "/spells/" + this.spellId;
    } else {
      return "#";
    }
  }, this);

  this.quickMemorizeUrl = ko.computed(function() {

    var data = {
      spell_id: this.spellId,
      memorized_spell_id: this.memorizedId,
      mode: this.mode()
    };

    return getContextRoot() + "/libraries/" + this.libraryId() + "/memorize_spell.js?" + $.param(data);
  }, this);

  this.castUrl = ko.computed(function() {

    var data = {
      memorized_spell_id: this.memorizedId,
      mode: this.mode()
    };

    return getContextRoot() + "/libraries/" + this.libraryId() + "/cast_spell.js?" + $.param(data);
  }, this);
}

SpellModel.prototype.libraryId = function() {
  return this.container.libraryId();
};

SpellModel.prototype.mode = function() {
  return this.container.mode();
};

SpellModel.prototype.update = function(spell) {
  this.isLearned(spell.is_learned);
  this.numberMemorized(spell.number_memorized);
  this.name(spell.name);
  this.components(spell.short_components);
  this.school(spell.formatted_school);
  this.description(spell.short_description);
};